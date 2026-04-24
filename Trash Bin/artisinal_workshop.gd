extends Workplace
class_name Artisinal_Workshop


var base_output = {
	Goods.FURNITURE[Goods.name]: 5,
}

# Called when the node enters the scene tree for the first time.
func _init(region: Region) -> void:
	self.workplace_type = WP.ARTISINAL
	self.region = region
	self.size = 1
	self.base_employment_per_level = {
		Poptypes.ARTISAN: 100,
	}
	self.employment_per_level = base_employment_per_level
	self.workers[Poptypes.ARTISAN] = Pop.new(0,self,Poptypes.ARTISAN)
	self.wages[Poptypes.ARTISAN] = 2
	GameState.workplace_register.append(self)
	
	base_employment_per_level = {
	Poptypes.ARTISAN: 100,
}


func calculate_output():
	var output = {}
	output[Goods.FURNITURE[Goods.name]] = actual_input[Goods.WOOD[Goods.name]] * base_output[Goods.FURNITURE[Goods.name]]
	return output
