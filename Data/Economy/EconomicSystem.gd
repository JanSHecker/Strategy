extends Node
class_name EconomicSystem

var offers = {}
var requests = {}

var target_region_id
const MIN_TRADE = 10.0
const MAX_TRADES_PER_GOOD = 3
var rust_economy


@export var region_panel: Control

func _ready() -> void:
	GameState.economic_system = self
	if ClassDB.class_exists("EconomicRust") and ClassDB.can_instantiate("EconomicRust"):
		rust_economy = ClassDB.instantiate("EconomicRust")
	assert(rust_economy != null, "EconomicRust extension is required. The GDScript trade path is kept only for reference.")

#func _init() -> void:
	#for good in Goods.goods_list:
		#offers[good] = []


func econmic_cycle():
	reset_cycle()
	produce()
	offer()
	request()
	market()
	update_market()
	UI.update_workplace_panel()
	UI.update_country_panel()
	region_panel.on_update_region_panel()
	UI.update_pop_panel()

func market():
	trade_cycle_rust()
func request():
	for region in GameState.regions.values():
		for workplace in region.workplaces.values():
			workplace.production.send_order()
		for construction in region.constructions:
			construction.send_order()
	for pop in GameState.pop_register:
		pop.consume()
	requests.clear()



func update_market():
	for country in GameState.countries.values():
		for region_id in country.regions:
			var region = GameState.regions.get(region_id)
			region.market.resolve_offers()
			region.market.resolve_orders()
			for workplace in region.workplaces.values():
				workplace.calculate_finances()
			for construction in region.constructions:
				construction.check_progress()
			for pop in region.pops.values():
				pop.evaluate_consumption()
				
			region.market.adjust_prices()
		country.finances.calculate_balance()
		country.private_investment.process_cycle()

func reset_cycle():
	for country in GameState.countries.values():
		country.finances.reset_cycle()
		country.private_investment.reset_cycle()
	for region in GameState.regions.values():
		region.market.reset_cycle()
		


func produce():
	for region in GameState.regions.values():
		for workplace in region.workplaces.values():
			workplace.production.throughput()
			
			
func offer():
	offers.clear()
		

	
	
	

	
	
func trade3(good:String ,good_requests: Dictionary, good_offers: Dictionary):

	var good_requests_filtered = TradeLogic.filter_offers_or_requests(good_requests)

	for key in good_requests_filtered:
		var request = good_requests[key]
		var offer = good_offers[key]
		var trade = TradeLogic.conduct_local_trade(request,offer)
		var target_market = GameState.regions.get(trade["market"]).market
		request["amount"] -= trade["amount"]
		offer["amount"] -= trade["amount"]
		target_market.sold_supply[good] += trade["amount"]
		target_market.supplied_demand[good] += trade["amount"]
		
	
	good_requests_filtered = TradeLogic.filter_offers_or_requests(good_requests_filtered)
	var good_offers_filtered = TradeLogic.filter_offers_or_requests(good_offers)
	good_requests_filtered.sort()
	for region_id_request in good_requests_filtered:
		var request = good_requests_filtered[region_id_request]
		var desired_amount = request["amount"]
		if desired_amount <= 0:
			continue
		var target_market = request["market"]
		var viable_imports = TradeLogic.filter_viable_offers(good_offers_filtered,target_market, good)
		
		var number_of_trades_per_good = 0
		while desired_amount > 0.0 and len(viable_imports.keys()) > 0 and number_of_trades_per_good < MAX_TRADES_PER_GOOD:
			var calculated_import_amounts = await calculate_import_amounts(viable_imports,target_market, desired_amount, good)
			var best_offer = calculated_import_amounts.values().reduce(func(best, current):
				return current if current["trade_amount"] < best["trade_amount"] else best)
			if best_offer == null: 
				viable_imports = {}
			else:
				number_of_trades_per_good += 1
				var source_market = best_offer["market"]
				var trade_quantity = best_offer["trade_amount"]
				desired_amount -= trade_quantity
				best_offer["amount"] -= trade_quantity
				source_market.sold_supply[good] += trade_quantity #increase realized supply in source market
				source_market.export[good] += trade_quantity
				target_market.import[good] += trade_quantity
				target_market.supplied_demand[good] += trade_quantity #increase realized demand in source market
				target_market.offer_price_volume[good] += trade_quantity * (best_offer["market"].equilibrium_prices[good] + best_offer["transport"])
				target_market.register_external_trade(source_market,target_market,trade_quantity,good)
				source_market.register_external_trade(source_market,target_market,trade_quantity,good)
				if best_offer["amount"] <= 0.0:
					viable_imports.erase(best_offer["market"].region.id)


func trade_cycle_rust():
	var region_ids := PackedStringArray()
	var region_inputs: Array = []
	var distance_matrix: Array = []
	var good_names := PackedStringArray()
	var good_weights := PackedFloat64Array()
	for good_name in Goods.goods_list.keys():
		good_names.append(good_name)
		good_weights.append(Goods.goods_list[good_name].weight)

	for region_id in GameState.regions.keys():
		var region = GameState.regions[region_id]
		var market: Market = region.market
		region_ids.append(region_id)
		region_inputs.append({
			"region_id": region_id,
			"prices": _collect_market_metric(market.prices, good_names),
			"equilibrium_prices": _collect_market_metric(market.equilibrium_prices, good_names),
			"offered_supply": _collect_market_metric(market.offered_supply, good_names),
			"latent_demand": _collect_market_metric(market.latent_demand, good_names),
			"sold_supply": _collect_market_metric(market.sold_supply, good_names),
			"supplied_demand": _collect_market_metric(market.supplied_demand, good_names),
			"export_amounts": _collect_market_metric(market.export, good_names),
			"import_amounts": _collect_market_metric(market.import, good_names),
			"offer_price_volumes": _collect_market_metric(market.offer_price_volume, good_names),
		})

	for source_region_id in region_ids:
		var row := PackedFloat64Array()
		var source_distances = GameState.transportation_network.cached_distances.get(source_region_id, {})
		for target_region_id in region_ids:
			row.append(source_distances.get(target_region_id, 0.0))
		distance_matrix.append(row)

	var result: Dictionary = rust_economy.simulate_market_cycle(
		region_inputs,
		region_ids,
		good_names,
		good_weights,
		distance_matrix,
		MIN_TRADE,
		MAX_TRADES_PER_GOOD
	)
	apply_trade_cycle_results(result, good_names)


func apply_trade_cycle_results(result: Dictionary, good_names: PackedStringArray):
	for region_result in result["regions"]:
		var payload: Dictionary = region_result
		var region = GameState.regions[payload["region_id"]]
		var market: Market = region.market
		_apply_market_metric(market.sold_supply, good_names, payload["sold_supply"])
		_apply_market_metric(market.supplied_demand, good_names, payload["supplied_demand"])
		_apply_market_metric(market.export, good_names, payload["export_amounts"])
		_apply_market_metric(market.import, good_names, payload["import_amounts"])
		_apply_market_metric(market.offer_price_volume, good_names, payload["offer_price_volumes"])

	for raw_trade in result["trades"]:
		var trade: Dictionary = raw_trade
		var source_region = GameState.regions[trade["source_region_id"]]
		var target_region = GameState.regions[trade["target_region_id"]]
		var source_market: Market = source_region.market
		var target_market: Market = target_region.market
		target_market.register_external_trade(source_market, target_market, trade["amount"], trade["good"])
		source_market.register_external_trade(source_market, target_market, trade["amount"], trade["good"])


func _collect_market_metric(metric: Dictionary, good_names: PackedStringArray) -> PackedFloat64Array:
	var values := PackedFloat64Array()
	for good_name in good_names:
		values.append(metric.get(good_name, 0.0))
	return values


func _apply_market_metric(metric: Dictionary, good_names: PackedStringArray, values: PackedFloat64Array):
	for index in range(good_names.size()):
		metric[good_names[index]] = values[index]


func calculate_import_amounts(viable_imports: Dictionary,target_market: Market, desired_amount: float, good: String):
	var imports_with_amounts = {}
	for imports_key in viable_imports:
		var item = viable_imports[imports_key]
		var results = await get_arbitrage_amount(
			item["market"], 
			desired_amount, 
			target_market, 
			item["amount"], 
			good, 
			item["transport"]
			)
		if results[0] > MIN_TRADE:
			imports_with_amounts[imports_key] = item
			item["trade_amount"] = snapped(results[0],0.01)
			item["source_price"] = results[1]
			item["target_price"] = results[2]
	return imports_with_amounts

func get_arbitrage_amount(source:Market, desired:float, target:Market, available:float, good: String, transport: float):
	await get_tree().process_frame
	var Q_low = 0.0
	var Q_high = min(desired, available)
	var best_Q = 0.0
	var tolerance = 0.01
	
	# Cache reusable values
	var source_price_base = source.equilibrium_prices[good]
	var source_supply = source.offered_supply[good]
	var source_demand = source.latent_demand[good] + source.export[good]

	var target_supply = target.offered_supply[good]
	var target_demand = target.latent_demand[good]
	var target_import = target.import[good]
	var target_offer_price_volume = target.offer_price_volume[good]

	var price_source_after = 0.0
	var price_target_after = 0.0

	while Q_high - Q_low > tolerance:
		var Q_mid = (Q_low + Q_high) / 2

		# Compute new prices based on Q_mid
		price_source_after = compute_price(
			source_price_base,
			source_supply,
			source_demand + Q_mid
		)
		var target_price_volume_after_trade = target_offer_price_volume + source_price_base * Q_mid
		var target_amount_of_offers = target_supply + target_import + Q_mid
		
		var target_base_price = target_price_volume_after_trade / target_amount_of_offers

		price_target_after = compute_price(
			target_base_price,
			target_supply + Q_mid + target_import,
			target_demand
		)

		if (price_source_after + transport + 0.2) < price_target_after:
			best_Q = Q_mid
			Q_low = Q_mid  # Try higher trade
		else:
			Q_high = Q_mid  # Try lower trade

	return [best_Q, price_source_after, price_target_after]

func compute_price(baseprice, supply, demand):
	var pricefactor = 1.0 + (demand - supply) / (supply + 1.0)
	pricefactor = clamp(pricefactor, 0.25, 1.75)  # Your existing bounds
	return snapped(baseprice * pricefactor,0.01)
