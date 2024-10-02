extends Resource
class_name Pop

var size: int
var workforce_size: int
var workforce_ratio = 0.25
var workplace: Workplace
var type: String
var birthrate= 0.06
var deathrate= 0.04

# Called when the node enters the scene tree for the first time.
func _init(workforce: int, workplace: Workplace, type: String ) -> void:
	self.workforce_size = workforce
	self.size = workforce / workforce_ratio
	print(size)
	self.workplace = workplace
	self.type = type
	workplace.location.pops.append(self)
	GameState.pop_register.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func population_growth_tic():
	var monthly_rate = pow(1 + birthrate-deathrate, 1.0 / 12.0)
	size = max(monthly_rate * size,size+1)
	workforce_size = size * workforce_ratio
	trim_workforce()
	print(workforce_size)
	
func transfer_workforce(amount: int,targetPop: Pop):          #We transfer population as workforce
	var actual_transfer = 0
	if amount <= workforce_size:
		workforce_size -= amount
		targetPop.workforce_size += amount
		actual_transfer = amount
	else:
		targetPop.workforce_size += workforce_size
		actual_transfer = workforce_size
		workforce_size = 0
		
	self.update_wsize_to_size()
	targetPop.update_wsize_to_size()
	return actual_transfer

func trim_workforce():
	if workplace.workplace_type != WP.SUBSITANCE:
		if workforce_size > workplace.base_employment_per_level[type] * workplace.size:
			var surplus_workforce = workforce_size - workplace.base_employment_per_level[type] * workplace.size
			
			transfer_workforce(surplus_workforce, workplace.location.workplaces[WP.SUBSITANCE].workers[Poptypes.PEASANT])
			
			
func wants_to_change_job(future_workplace: Workplace, poptype: String, desired_amount: int):
	if workplace.wages[self.type] * 1.2 < future_workplace.wages[poptype]:
		return true
	return false

func update_wsize_to_size():
	size = workforce_size * (1/workforce_ratio)
