extends Resource
class_name Good

var name: String
var category: String
var baseprice: float
var weight: float

func _init(name: String, category: String, price: float, weight:float) -> void:
	self.name = name
	self.category = category
	self.baseprice = price
	self.weight = weight
