extends Node
class_name TradeLogic

static func filter_offers_or_requests(offer_or_requests: Dictionary) -> Dictionary:
	var filtered = {}
	for region_id in offer_or_requests:
		if offer_or_requests[region_id]["amount"] > 0.0:
			filtered[region_id] = offer_or_requests[region_id]
	return filtered

static func conduct_local_trade(request: Dictionary, offer: Dictionary) -> Dictionary:
	var locally_traded_amount = min(request["amount"],offer["amount"])
	assert(request["market"].region.id == offer["market"].region.id)
	var market_id = request["market"].region.id
	var trade = {
		"amount": locally_traded_amount,
		"market": market_id,
	}
	return trade

static func filter_viable_offers(offers: Dictionary, target_market: Market, good: String) -> Dictionary:
	var viable_imports = {}
	var good_data = Goods.goods_list.get(good)
	for region_id in offers:
			var offer = offers[region_id]
			var source_market = offer["market"]
			offer["transport"] = get_transport_cost(source_market, target_market, good_data)
			if source_market.prices[good] < target_market.prices[good]:
				viable_imports[region_id] = offer
	return viable_imports

static func get_transport_cost(source: Market,target: Market,good: Good) -> float:
	if source == target:
		return 0
	var shortest_path = GameState.transportation_network.get_cached_shortest_path(source.region,target.region)
	var transport_cost =  0.5 * shortest_path * good.weight
	return transport_cost
