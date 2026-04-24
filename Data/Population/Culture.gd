extends Resource
class_name Culture

static var DEFAULT = Culture.new("default")
var name


func _init(name: String) -> void:
	self.name = name
