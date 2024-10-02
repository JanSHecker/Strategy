extends Resource
class_name Market

var trade_guild

var province: Province

var goods_baseprice = {
	Goods.GRAIN: 10,
	Goods.WOOD: 10,
	Goods.ALCOHOL: 10,
	Goods.STONE: 20,
	Goods.COAL: 30,
	Goods.IRON: 30,
	Goods.STEEL: 50,
	Goods.FABRIC: 20,
	Goods.CLOTHING: 40,
	Goods.FURNITURE: 40,
	
}

var resource_stocks = {}

var demand = {
	Goods.GRAIN: 0,
	Goods.WOOD: 0,
	Goods.ALCOHOL: 0,
	Goods.STONE: 0,
	Goods.COAL: 0,
	Goods.IRON: 0,
	Goods.STEEL: 0,
	Goods.FABRIC: 0,
	Goods.CLOTHING: 0,
	Goods.FURNITURE: 0,
}

var order_register = {}

# Called when the node enters the scene tree for the first time.
func _init(province: Province) -> void:
	for good in goods_baseprice:
		resource_stocks[good] = Stock.new(good,goods_baseprice[good])
	self.province = province

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func import():
	pass
	
func export():
	pass

func sell(good: String,quantity: float):
	resource_stocks[good].quantity += quantity
	return quantity * resource_stocks[good].price
	
func accept_order(order: Dictionary, workplace: Workplace):
	order_register[workplace.workplace_type] = order
	for good in order.keys():
		demand[good] += order[good]

func resolve_demand():
	var actually_bought = {}
	var supply_percentage = {}
#detect shortages in the market
	for good in demand.keys():
		actually_bought[good] = min(demand[good], resource_stocks[good].quantity)
		if demand[good] > 0:
			supply_percentage[good] = actually_bought[good] / demand[good]
		else:
			supply_percentage[good] = 1

#look for the good in the order with the lowest fulfillment to keep the input proportional	
	for workplace in order_register:
		var order_fulfillment = {}
		var lowest_fulfillment = 1
		for good in order_register[workplace].keys():
			if lowest_fulfillment > supply_percentage[good]:
				lowest_fulfillment = supply_percentage[good]
		for good in order_register[workplace].keys():
			order_fulfillment[good] = snapped(order_register[workplace][good] * lowest_fulfillment,1)
		province.workplaces[workplace].actual_input = order_fulfillment
	reset_demand()



func reset_demand():
	demand = {
	Goods.GRAIN: 0,
	Goods.WOOD: 0,
	Goods.ALCOHOL: 0,
	Goods.STONE: 0,
	Goods.COAL: 0,
	Goods.IRON: 0,
	Goods.STEEL: 0,
	Goods.FABRIC: 0,
	Goods.CLOTHING: 0,
	Goods.FURNITURE: 0,
}
