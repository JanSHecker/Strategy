extends Workplace
class_name Logging_Camp


var base_output = {
	Goods.WOOD: 1,
}

var assets

# Called when the node enters the scene tree for the first time.
func _init(location: Province) -> void:
	base_employment_per_level = {
	Poptypes.WORKER: 100,
}
	self.workplace_type = WP.LOGGING
	self.location = location
	self.size = 1
	self.employment_per_level = base_employment_per_level
	self.workers[Poptypes.WORKER] = Pop.new(10,self,Poptypes.WORKER)
	self.wages[Poptypes.WORKER] = 1
	GameState.workplace_register.append(self)
	base_employment_per_level = {
		Poptypes.WORKER: 100,
	}
	self.assets = {
		AssetDefinition.manual_tools_logging: get_asset(AssetDefinition.manual_tools_logging)
	}

func send_order():
	pass


func calculate_output():
	var output = {}
	output[Goods.WOOD] = base_output[Goods.WOOD] * get_workforce_size(Poptypes.WORKER) * productivity
	return output
