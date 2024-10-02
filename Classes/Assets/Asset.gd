extends Resource
class_name Asset

var asset_type: String
var asset_amount: int
var workplace: Workplace
var asset_maximum_per_level: int
var asset_cost: Dictionary
var additional_employment_per_level:Dictionary
var additional_input_per_level:Dictionary
var additional_output_per_level:Dictionary
var asset_decay_per_year: int

func _init(asset_type: String, asset_maximum_per_level: int, asset_cost: Dictionary, additional_employment_per_level:Dictionary, additional_input_per_level:Dictionary, additional_output_per_level:Dictionary, asset_decay_per_year: int):
	self.asset_type = asset_type
	self.asset_amount = 0
	self.asset_maximum_per_level = asset_maximum_per_level
	self.asset_cost = asset_cost
	self.additional_employment_per_level = additional_employment_per_level
	self.additional_output_per_level = additional_output_per_level
	self.asset_decay_per_year = asset_decay_per_year

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
