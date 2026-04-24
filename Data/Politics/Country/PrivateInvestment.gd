extends Node
class_name PrivateInvestment
#The Country that the investors reside in
var country: Country

#The budget of the investors
var budget = 0.0
var deposits_in_last_cycle = []
var sum_of_deposits_in_last_cycle = 0.0

enum deposit_dict {
	WORKPLACE,
	REGION,
	AMOUNT,
}

func _init(country: Country) -> void:
	self.country = country
	

func deposit(amount: float, source: Workplace):
	amount = snapped(amount,0.01)
	budget += amount
	deposits_in_last_cycle.append({
		deposit_dict.WORKPLACE: source.workplace_type,
		deposit_dict.REGION: source.region,
		deposit_dict.AMOUNT: amount,
	})


func process_cycle():
	return

func reset_cycle():
	deposits_in_last_cycle = []
	sum_of_deposits_in_last_cycle = 0.0

func invest(target_structure: Structure):
	var owner = {
		
	}
