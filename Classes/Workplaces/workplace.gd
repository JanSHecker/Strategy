extends Resource

class_name Workplace

var workplace_type
var workers = {}
var size: int
var location: Province
var productivity = 1
var cash_reserve = 0
var base_employment_per_level
var employment_per_level
var order_input = {} #the modified base input thats ordered
var actual_input = {} #the actual input the workplace recieves from the market
var input_price = 0
var turnover = 0
var profit = 0
var wages = {}
var total_wage_costs = 0
var output = {}

func get_workforce_size(poptype: String):
	if workers != null:
		return workers[poptype].workforce_size
	else:
		return 0

func employ(desired_hires: int, poptype: String):
	for pop in location.pops:
		if pop.wants_to_change_job(self,poptype,desired_hires):
			var transfered = pop.transfer_workforce(desired_hires, workers[poptype])
			desired_hires -= transfered
			if desired_hires == 0:
				return

func throughput():
	input_price = 0
	if actual_input != null:
		for good in actual_input:
			input_price += location.market.resource_stocks[good].price * actual_input[good]
	
	output = calculate_output()
	turnover = 0
	for good in output:
		turnover += location.market.sell(good,output[good]) - input_price
	#print("profit: " + str(profit))
	total_wage_costs = 0
	for poptype in workers:
		total_wage_costs += wages[poptype] * workers[poptype].workforce_size
	profit = turnover - input_price - total_wage_costs
	cash_reserve += profit
	
	
func calculate_output():
	pass #to be overidden

func get_missing_employment():
	var missing_employment = {}
	for poptype in employment_per_level:
		if workers[poptype].workforce_size < employment_per_level[poptype] * size:
			missing_employment[poptype] = employment_per_level[poptype] * size - workers[poptype].workforce_size
		return missing_employment	
	
func can_afford_wages(desired_hires: Dictionary):
	var projected_hires = {}
	var projected_wage_cost = 0
	
	for poptype in desired_hires:
		projected_hires[poptype] = min(int(employment_per_level[poptype]* 0.05), desired_hires[poptype])
		projected_wage_cost +=  projected_hires[poptype] * wages[poptype]
	if profit > projected_wage_cost:
		return true
	return false
		
func has_no_workers():
	var sum = 0
	for poptype in workers:
		sum += workers[poptype].workforce_size	
	if sum == 0:
		return true
	return false
	
func get_maximum_total_employment():
	var total_employment = 0
	for poptype in workers:
		total_employment += employment_per_level[poptype] * size
	return total_employment
		

func get_current_total_employment():
	var total_employment = 0
	for poptype in workers:
		total_employment += get_workforce_size(poptype)
	return total_employment
		
