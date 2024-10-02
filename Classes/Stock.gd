extends Resource
class_name Stock

var good:String
var quantity:float
var price:float
var demand_forecast:float
	

# Called when the node enters the scene tree for the first time.
func _init(good: String, price: float):
	self.good = good
	self.quantity = 0
	self.price = price


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
