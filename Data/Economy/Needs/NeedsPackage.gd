extends Resource
class_name NeedsPackage

var level: int

static var basic_food = Need.new(
	{
		Goods.GRAIN.name: 0.9,
		Goods.MEAT.name: 0.05,
		Goods.GROCERIES.name : 0.05,
	}
)

static var extra_food = Need.new(
	{
		Goods.GRAIN.name: 0.6,
		Goods.MEAT.name: 0.2,
		Goods.GROCERIES.name: 0.2,
	
	}
)
static var basic_clothing = Need.new( 
	{
		Goods.FABRIC.name:0.6,
		Goods.CLOTHING.name:0.4,
	}
)
static var vices = Need.new(
	{
	Goods.ALCOHOL.name:0.5,
	Goods.TOBACCO.name:0.5,
	}
)
static var basic_furniture = Need.new({
	Goods.WOOD.name:0.6,
	Goods.FURNITURE.name:0.4,
})

static var heating = Need.new({
	Goods.WOOD.name: 0.5,
	Goods.COAL.name: 0.5,
})

static var luxury_food = Need.new({
	Goods.MEAT.name:0.9,
	Goods.DELICACIES.name:0.1,

})

static var stimulants = Need.new({
	Goods.TEA.name:0.5,
	Goods.COFFEE.name:0.5,
})

static var survival_needs = [
	basic_food,
	basic_clothing,
]
