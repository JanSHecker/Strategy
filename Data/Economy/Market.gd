extends Resource
class_name Market


var region: Region
var supplied_demand = {} #what is available
var latent_demand = {} #what they want
var export = {}
var offered_supply = {}
var import = {}
var sold_supply = {}

var industry_order_register = {}
var consumption_order_register = {}
var construction_order_register = {}


var offer_register = {}
var offer_price_volume = {}

var local_trade_factor = {}
var prices = {}
var target_prices = {}
var equilibrium_prices = {}

var trade_history = []

var external_trade_registry = {}

# Called when the node enters the scene tree for the first time.
func _init(region: Region) -> void:
	self.region = region
	for good in Goods.goods_list.values():
		self.prices[good.name] = float(good.baseprice)
		self.local_trade_factor[good.name] = 0.8
	self.target_prices = prices.duplicate(true)
	self.equilibrium_prices = prices.duplicate(true)
	reset_cycle()
	




func accept_offer(amount: float, workplace: Workplace, good: Good, price: float):
	offer_register[good.name].append({
		"amount": amount,
		"workplace":workplace,
	})
	offered_supply[good.name] += amount
	offer_price_volume[good.name] += amount * price
	
func accept_comsumption_order(pop: Pop, good: Good, amount: float):
	consumption_order_register[good.name].append({
		"amount": amount,
		"pop": pop,
	})
	latent_demand[good.name] += amount

func accept_construction_order(construction: Construction, good: Good, amount: float):
	construction_order_register[good.name].append({
		"amount": amount,
		"construction": construction,
	})
	latent_demand[good.name] += amount


func accept_order(amount: float, workplace: Workplace, good: Good):
	industry_order_register[good.name].append({
		"amount": amount,
		"workplace":workplace,
	})
	latent_demand[good.name] += amount

func resolve_offers():
	for good in Goods.goods_list:
		var sold_goods_ratio = float(sold_supply[good]) / offered_supply[good] if offered_supply[good] > 0.0 else 0.0
		for offer in offer_register[good]:
			var amount_sold = offer["amount"] * sold_goods_ratio
			var revenue = offer["amount"] * sold_goods_ratio * prices[good]
			offer["workplace"].resolve_sale(good,amount_sold,revenue)



func resolve_orders():
	for good in Goods.goods_list:
		var bought_goods_ratio = float(supplied_demand[good]) / latent_demand[good] if latent_demand[good] > 0.0 else 0.0
		for order in industry_order_register[good]:
			var traded_amount = order["amount"] * bought_goods_ratio
			order["workplace"].actually_bought[good] = snapped(traded_amount,0.01)
			order["workplace"].input_cost += snapped(traded_amount * prices[good],0.01 )

		for order in consumption_order_register[good]:
			var traded_amount = order["amount"] * bought_goods_ratio
			order["pop"].actually_bought[good] = snapped(traded_amount,0.01)
			
		var total_amount_for_construction = 0
		for order in construction_order_register[good]:
			total_amount_for_construction += order["amount"] * bought_goods_ratio
		for order in construction_order_register[good]:
			var traded_amount = min(order["amount"],total_amount_for_construction)
			total_amount_for_construction -= traded_amount
			order["construction"].delivered_goods[good] += snapped(traded_amount,0.01)
			order["construction"].costs += snapped(traded_amount * prices[good], 0.01)
	
func reset_cycle():
	set_zero()
	
	
func set_zero():
	for good in Goods.goods_list:
		latent_demand[good] = 0
		supplied_demand[good] = 0
		export[good] = 0
		offered_supply[good] = 0
		sold_supply[good] = 0
		import[good] = 0
		offer_price_volume[good] = 0
		offer_register[good] = []
		external_trade_registry[good] = []
		industry_order_register[good] = []
		consumption_order_register[good] = []
		construction_order_register[good] = []
	


func adjust_prices():
	for good in Goods.goods_list.values():
		var local_supply = offered_supply[good.name] + import[good.name]
		var baseprice = offer_price_volume[good.name] / local_supply if local_supply != 0.0 else good.baseprice #average price in market
		equilibrium_prices[good.name] = baseprice
		var supply = offered_supply[good.name]  + import[good.name]
		var demand = latent_demand[good.name] + export[good.name]
		var pricefactor = (1.0 + (demand - supply) / (supply + 1.0))
		pricefactor = min(1.75,max(pricefactor,0.25))
		var target_price = snapped(baseprice * pricefactor,0.01)
		target_prices[good.name] = target_price
		prices[good.name] = target_price  # Smooth adjustment

func get_request(good):
	var request = {
		"market":self,
		"amount":latent_demand[good],
		"price":prices[good],
	}
	return request
	
	
func get_offers(good):
	var offer = {
		"market":self,
		"amount":offered_supply[good],
		"price": prices[good],
	}
	assert(prices[good] == snapped(prices[good],0.01))
	return offer

func register_external_trade(source: Market, target: Market, amount: float, good: String):
	var external_trade = {
		"source" = source,
		"target" = target,
		"amount" = amount,
		"good" = good,
		"isExport" = true if source.region.id == self.region.id else false,
	}
	external_trade_registry[good].append(external_trade) 
