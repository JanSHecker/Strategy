extends Resource
class_name Production

var workplace: Workplace

#Production
var base_input = {}
var order_input = {} 
var actual_input = {}




var desired_production_scale: float
var production_scale: float




var output = {}
var actual_output = {}





func _init(workplace: Workplace) -> void:
	self.workplace = workplace



func calculate_input():
	var input = base_input.duplicate()
	workplace.update_production()
	desired_production_scale = float(workplace.get_current_total_employment()) / workplace.get_maximum_total_employment() * workplace.scale if workplace.get_maximum_total_employment() != 0 else 0
	for good in base_input:
		input[good] = base_input[good] * desired_production_scale 
	return input
	

func send_order():
	workplace.input_cost = 0.0
	order_input = calculate_input()
	for good in order_input:
		order_input[good] = snapped(order_input[good],0.01)
		workplace.region.market.accept_order(order_input[good],workplace,Goods.goods_list[good])
		
		
		
func throughput():
	actual_input = workplace.actually_bought.duplicate()
	production_scale = desired_production_scale
	for good in base_input:
		production_scale = min(production_scale,actual_input.get_or_add(good,0) / base_input[good] * workplace.scale) if  base_input[good] * workplace.scale != 0 else 0
	actual_output = calculate_output()
	var wage_costs = 0.0
	var opportunity_costs = 0.0
	for poptype in workplace.actual_employment:
		if poptype == Poptypes.PEASANT.name:
			opportunity_costs += workplace.actual_employment[poptype] * Poptypes.FARMHAND.base_wage / 10
		wage_costs += workplace.actual_employment[poptype] * Poptypes.poptype_list[poptype].base_wage
	workplace.total_wage_costs = wage_costs
	var propduction_costs = wage_costs + opportunity_costs + workplace.input_cost
	var output_total_value = 0
	var value_percentage_of_output = {}
	for good in actual_output:
		output_total_value += actual_output[good] * Goods.goods_list[good].baseprice
	
	for good in actual_output:
		value_percentage_of_output[good] = Goods.goods_list[good].baseprice * actual_output[good] / output_total_value if output_total_value != 0 else 0
		var price = (propduction_costs * value_percentage_of_output[good] * workplace.markup_factor) / actual_output[good] if actual_output[good] != 0 else 0
		
		workplace.region.market.accept_offer(
		actual_output[good],
		workplace,Goods.goods_list[good],
		price
		)
		
		
		
func calculate_output():
	var adjusted_output = {}
	var economy_of_scale_factor = 1.0 + (workplace.size-1.0)/100.0
	
	for good in output:
		var amount = output[good] * production_scale * economy_of_scale_factor
		adjusted_output[good] = snapped(amount,0.01)

	return adjusted_output
	
	
func set_output(good: String,amount: float):
	output[good] = amount
