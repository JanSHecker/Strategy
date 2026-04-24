extends Structure

class_name Workplace

var structure_type = structure_types.WORKPLACE

var workplace_type: Dictionary
var location: Province

#Market Signals
var productivity = 0.0


# Economy
var input_cost = 0.0
var total_wage_costs = 0.0
var turnover = 0.0
var profit = 0.0
var markup_factor = 1.2


#Workers
var desired_employment = {}
var actual_employment = {}
var wages = {}


var scale = 1.0

var actually_bought = {}
var actually_sold = {}

#Capital
var assets = {}
var cash_reserve: int
var reinvestment_rate = 0.15




func _init(region: Region,type: Dictionary, size: int) -> void:
	self.name = type[WP.name]
	self.region = region
	self.workplace_type = type
	self.size = size
	self.construction_goods_level = type[WP.base_construction].duplicate()
	update_production()
	


func employ(desired_hires: int, poptype: String):
	var unemployed = region.pops[Poptypes.UNEMPLOYED.name]

	var hired = unemployed.hire(poptype, desired_hires)
	if hired == 0 and poptype != Poptypes.PEASANT.name:
		var peasant = region.pops[Poptypes.PEASANT.name]
		hired = peasant.hire(poptype,desired_hires)
	actual_employment[poptype] += hired

func fire(desired_fires: int, poptype: String):
	var pop = region.pops[poptype]
	var fired = pop.fire(desired_fires)
	actual_employment[poptype] -= fired

func get_missing_employment():
	var missing_employment = {}
	for poptype in desired_employment:
		missing_employment[poptype] = desired_employment[poptype] - actual_employment.get_or_add(poptype,0)
	return missing_employment
	



		
func has_no_workers():
	var sum = 0
	for poptype in actual_employment:
		sum += actual_employment[poptype]
	if sum == 0:
		return true
	return false
	
func get_maximum_total_employment():
	var total_employment = 0
	for poptype in desired_employment:
		total_employment += desired_employment[poptype]
	return total_employment
		

func get_current_total_employment():
	var total_employment = 0
	for poptype in desired_employment:
		total_employment += actual_employment.get_or_add(poptype,0)
	return total_employment
		



func update_production():
	var production_scheme = workplace_type[WP.base_production]
	if profit < 0:
		scale = max(scale - 0.01, 0.05)
	if profit > (turnover * 0.2):
		scale = min(scale + 0.01, 1.0)
	
	profit = 0.0
	turnover = 0.0
	for poptype in production_scheme.workers:
		desired_employment[poptype] = production_scheme.workers[poptype] * size * scale
	for good in production_scheme.input:
		production.base_input[good] = production_scheme.input[good] * size
	for good in production_scheme.output:
		production.set_output(good,production_scheme.output[good] * size)

func resolve_sale(good,amount,revenue):
	actually_sold[good] = amount
	turnover += revenue
	if amount > 0:
		assert(revenue > 0)
	#if workplace_type == WP.LOGGING and region.region_id == 1 :
		#print("amount",amount)
		

func calculate_finances():
		var number_of_employees = get_current_total_employment()
		profit = turnover - input_cost - total_wage_costs
		productivity = (turnover - input_cost) / number_of_employees if number_of_employees > 0 else 0.0
		var cash_reserve_limit = 10_000 * size
		
		var amount_to_reserve = min(profit, cash_reserve_limit - cash_reserve)
		cash_reserve += amount_to_reserve
		
		assert(region.country != null, str(region))
		var country = GameState.countries.get(region.country)
		var private_investment = country.private_investment
		
		var after_cashreserves = profit - amount_to_reserve
		var to_reinvest = after_cashreserves * reinvestment_rate
		var to_dividends = after_cashreserves - to_reinvest
		private_investment.deposit(to_reinvest,self)
		#ownership.pay_dividends(to_dividends)
