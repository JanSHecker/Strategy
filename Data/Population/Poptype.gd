extends Resource
class_name Poptype

var name: String
var base_wage: float

func _init(name, wage) -> void:
	self.name = name
	self.base_wage = wage
