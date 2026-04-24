extends Workplace
class_name Logging_Camp


var base_output = {
	Goods.WOOD[Goods.name]: 1,
}



# Called when the node enters the scene tree for the first time.
func _init(region: Region) -> void:
	base_employment_per_level = {
	Poptypes.WORKER: 100,
}
	self.workplace_type = WP.LOGGING
	self.region = region
	self.size = 1
	self.employment_per_level = base_employment_per_level
	self.workers[Poptypes.WORKER] = Pop.new(10,self,Poptypes.WORKER)
	self.wages[Poptypes.WORKER] = 1
	GameState.workplace_register.append(self)
	base_employment_per_level = {
		Poptypes.WORKER: 100,
	}
	self.assets = {
		AssetDefinition.MANUAL_TOOLS_LOGGING: ManualToolsLogging.new(self),
		AssetDefinition.MECHANICAL_SAWS_LOGGING: MechanicalSawsLogging.new(self)
	}

func send_order():
	pass


func calculate_output():
	var output = {}
	output[Goods.WOOD[Goods.name]] = base_output[Goods.WOOD[Goods.name]] * get_workforce_size(Poptypes.WORKER) 
	return output
