extends Resource
class_name Need

var type: String
var Goods
var units: int

func _init(goods):
	self.Goods = goods


	
	
func substitute_good(prior_good,substitute_good, amount: float):
	if Goods[prior_good] >= amount && Goods[substitute_good] <= 1:
		Goods[prior_good] -= amount
		Goods[substitute_good] += amount
	
	
