extends Workplace

class_name Subsistance_Farm

var subsistance_grain_consumption = 1



# Called when the node enters the scene tree for the first time.
func _init(region: Region) -> void:
	self.region = region
	self.workers[Poptypes.PEASANT] = Pop.new(region.generate_population()/4,self,Poptypes.PEASANT)
	self.wages[Poptypes.PEASANT] = 0
	GameState.workplace_register.append(self)
	self.workplace_type = WP.SUBSISTANCE
func send_order():
	pass




func calculate_output(): 
	var output = {}
	var grain_output = snapped(1.1 * get_workforce_size(Poptypes.PEASANT),1)
	output[Goods.GRAIN[Goods.name]] = grain_output - subsistance_grain_consumption * get_workforce_size(Poptypes.PEASANT)
	return output

func get_maximum_total_employment():
	return 100000
