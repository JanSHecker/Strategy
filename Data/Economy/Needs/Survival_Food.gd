extends Need
class_name NeedSurvivalFood



func _init():
	max_level = 10
	Goods = {
		Goods.GRAIN.name: 0.9,
		Goods.MEAT.name: 0.1,
	}
