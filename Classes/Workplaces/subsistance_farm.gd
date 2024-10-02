extends Workplace

class_name Subsistance_Farm

var subsistance_grain_consumption = 1



# Called when the node enters the scene tree for the first time.
func _init(location: Province) -> void:
	self.workplace_type = WP.SUBSITANCE
	self.location = location
	self.workers[Poptypes.PEASANT] = Pop.new(location.population * 0.25,self,Poptypes.PEASANT)
	self.wages[Poptypes.PEASANT] = 0
	GameState.workplace_register.append(self)

func send_order():
	pass




func calculate_output(): 
	var output = {}
	var grain_output = snapped(1.1 * productivity * get_workforce_size(Poptypes.PEASANT),1)
	output[Goods.GRAIN] = grain_output - subsistance_grain_consumption * get_workforce_size(Poptypes.PEASANT)
	return output

func get_maximum_total_employment():
	return 100000
