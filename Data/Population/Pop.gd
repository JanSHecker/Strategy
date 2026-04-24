extends Resource
class_name Pop



#pop dimensions
var type: Poptype
var region: Region
var culture: Culture

var consumption_level = 1
var survival_needs_lv
var life_needs_lv
var luxury_needs_lv
const CONSUMPTION_CHANGE_TRESHOLD = 0.3



var popID: int
var size: int



var workforce_size: float
var workforce_ratio = 0.25



var actually_bought = {}
var budget = 0.0
var expenses = 0.0
var balance = 0.0

var birthrate= 0.06
var deathrate= 0.04
var needs = {}
var need_substitutions = {}
const SUBSTITUTION_RATE = 0.01
const MINIMAL_SUBSTITUTION = 0.01
const MAXIMAL_SUBSTITUTION = 0.99
var goods_per_need = {}
var fulfilled_per_need = {}
var fulfillment_rate = {}

var sum_per_group = {}
var avg_per_group = {}
# Called when the node enters the scene tree for the first time.
func _init(size: int, type: Poptype, region: Region ) -> void:
	self.size = size
	self.workforce_size = size * workforce_ratio
	self.type = type
	self.region = region
	for need_key in Needs.NEEDS:
		var need = Needs.NEEDS[need_key]
		need_substitutions[need_key] = {}
		for good in need:
			need_substitutions[need_key][good] = need[good]["default"]
	GameState.pop_register.append(self)
	


func population_growth_tic():
	var monthly_growth_factor =  (birthrate - deathrate) / 12.0
	if type == Poptypes.PEASANT or type == Poptypes.UNEMPLOYED: 
		size = size * (1 +  monthly_growth_factor)
	else:
		region.pops[Poptypes.UNEMPLOYED.name].size += self.size * monthly_growth_factor
		


func consume():
	if type == Poptypes.PEASANT:
		return
	var consumption = Consumption_Level.consumption_levels[consumption_level]
	var needed_goods = {}
	goods_per_need = {}
	survival_needs_lv = consumption[Needs.NEED_GROUPS.SURVIVAL_NEEDS]
	life_needs_lv = consumption[Needs.NEED_GROUPS.LIFE_NEEDS]
	luxury_needs_lv = consumption[Needs.NEED_GROUPS.LUXURY_NEEDS]
	needs = {
		Needs.NEED_GROUPS.SURVIVAL_NEEDS: Consumption_Level.survival_consumption_levels.get_or_add(survival_needs_lv,{}),
		Needs.NEED_GROUPS.LIFE_NEEDS: Consumption_Level.life_consumption_levels.get_or_add(life_needs_lv,{}),
		Needs.NEED_GROUPS.LUXURY_NEEDS: Consumption_Level.luxury_consumption_levels.get_or_add(luxury_needs_lv,{}),
	}

	for need_group in needs:
		for need in needs[need_group]:
			var overall_amount = needs[need_group][need]
			var goods = Needs.NEEDS[need]
			goods_per_need[need] = {}
			for good in goods:
				var amount = snapped(need_substitutions[need][good] * overall_amount * (size / 1000.0),0.01)
				needed_goods[good] = needed_goods.get_or_add(good,0.0) + amount
				goods_per_need[need][good] = amount
	for good in needed_goods:
		region.market.accept_comsumption_order(self,good,needed_goods[good])

func update_workforce():
	workforce_size = size * workforce_ratio

func transfer(target_pop: Pop, amount: int):
	amount = min(self.size,amount)
	self.size -= amount
	update_workforce()
	target_pop.size += amount
	target_pop.update_workforce()
	return amount
	
func hire(target_poptype: String, amount: int):
	if not region.pops.has(target_poptype):
		region.pops[target_poptype] = Pop.new(0,Poptypes.poptype_list[target_poptype],region)
	var amount_with_dependents = self.transfer(region.pops[target_poptype],amount/workforce_ratio)
	amount = amount_with_dependents * workforce_ratio
	return int(amount)

func fire(amount: int):
	var unemployed = region.pops[Poptypes.UNEMPLOYED.name]
	amount = transfer(unemployed,amount)
	return amount

func pay_taxes(income: float):
	var country_id = region.country
	var country = GameState.countries.get(country_id)
	if country == null:
		return income
	var flat_tax = country.tax_code["per_capita"] * workforce_size
	var income_tax = country.tax_code["income"] * income
	var finances = country.finances
	finances.incomes[finances.income_types.PER_CAPITA_TAX] += flat_tax
	finances.incomes[finances.income_types.INCOME_TAX] += income_tax
	return flat_tax + income_tax

func evaluate_consumption():
	var recieved_goods = actually_bought.duplicate()
	for need_key in goods_per_need:
		var need = goods_per_need[need_key]
		fulfilled_per_need[need_key] = {}
		fulfillment_rate[need_key] = {}
		for good in need:
			var fulfilled_need = min(need[good], recieved_goods[good.name])
			fulfillment_rate[need_key][good] = fulfilled_need / need[good] if need[good] > 0.0 else 1.0
			fulfilled_per_need[need_key][good] = fulfilled_need
	expenses = 0.0
	for good in actually_bought:
		expenses += actually_bought[good] * region.market.prices[good]
	var income = workforce_size * region.wages[type.name]
	budget = income - pay_taxes(income)
	balance = budget - expenses
	adjust_consumption_level()
	adjust_substitution()
	
func adjust_consumption_level():
	var sum_fulfillment = 0.0

	for group in fulfillment_rate:
		sum_per_group[group] = 0.0
		for need in fulfillment_rate[group]:
			sum_per_group[group] += fulfillment_rate[group][need]
			sum_fulfillment += fulfillment_rate[group][need]
		avg_per_group[group] = sum_per_group[group] / len(fulfillment_rate[group])
	var avg_ful = sum_fulfillment / len(fulfillment_rate)
	if avg_ful > 0.8 and avg_per_group[0] >= 0.95 and avg_per_group[1] > 0.8 and avg_per_group[2] > 0.6:
		if balance >= budget * CONSUMPTION_CHANGE_TRESHOLD:
			consumption_level += 1 if consumption_level < 99 else 0
		if balance <= - budget * CONSUMPTION_CHANGE_TRESHOLD:
			consumption_level -= 1 if consumption_level > 1 else 0

func adjust_substitution():
	for need_group in needs:
		for need in needs[need_group]:
			var avg = 0
			for good in fulfillment_rate[need]:
				avg += fulfillment_rate[need][good] / fulfillment_rate[need].size()
			if  avg < 1.0:
				var fufilled_goods = []
				var unfufilled_goods = []
				for good in goods_per_need[need]:
					if fulfillment_rate[need][good] >= 1.0:
						fufilled_goods.append(good)
					else:
						unfufilled_goods.append(good)
				if len(fufilled_goods) > 0:
					for good in unfufilled_goods:
						substitute(need,good,fufilled_goods)

func substitute(need ,good: Good,substitutes: Array):
	var substitution = min(need_substitutions[need][good], SUBSTITUTION_RATE)
	assert(substitution >= 0.0, "Substitution negative")
	substitutes.sort()
	for i in range(0,len(substitutes)):
		var a = 1.0 - need_substitutions[need][substitutes[i]]
		var b =  substitution / (len(substitutes) - i)
		var amount = min(a,b)
		need_substitutions[need][substitutes[i]] += amount
		need_substitutions[need][good] -= amount
		assert(0.0 <= need_substitutions[need][good] and need_substitutions[need][good] <= 1.0)
		assert(0.0 <= need_substitutions[need][substitutes[i]] and need_substitutions[need][substitutes[i]] <= 1.0)
		substitution -= amount
 
