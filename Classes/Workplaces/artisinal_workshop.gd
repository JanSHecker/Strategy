extends Workplace
class_name Artisinal_Workshop


var base_input = {
	Goods.WOOD: 1,
}


var base_output = {
	Goods.FURNITURE: 1,
}

# Called when the node enters the scene tree for the first time.
func _init(location: Province) -> void:
	self.workplace_type = WP.ARTISINAL
	self.location = location
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

func send_order():
	order_input = base_input.duplicate()
	for good in order_input:
		order_input[good] = order_input[good] * get_workforce_size(Poptypes.ARTISAN)
	location.market.accept_order(order_input,self)

func calculate_output():
	var output = {}
	output[Goods.FURNITURE] = actual_input[Goods.WOOD] * base_output[Goods.FURNITURE] * productivity
	return output
