extends Resource
class_name Asset

var asset_type: String
var asset_amount: int = 0
var workplace: Workplace
var asset_maximum_per_level: int
var asset_cost: Dictionary
var additional_employment_per_level:Dictionary
var additional_input_per_level:Dictionary
var additional_output_per_level:Dictionary
var asset_decay_per_year: int

func _init(workplace: Workplace):
	self.workplace = workplace

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func get_asset_coverage_percentage():
	return snapped(asset_amount / (asset_maximum_per_level * workplace.size), 0.01)
