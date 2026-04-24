extends Resource
class_name BC

# Total cost: 13,500 (Wood: 10,500 + Stone: 3,000)
static var RURAL = {
	Goods.WOOD.name: 700, 
	Goods.STONE.name: 300, 
}

# Total cost: 26,000 (Wood: 12,000 + Stone: 6,000 + Iron: 8,000)
static var WORKSHOP = {
	Goods.WOOD.name: 800,
	Goods.STONE.name: 600,
	Goods.IRON.name: 400,
}

# Total cost: 169,000 (Wood: 12,000 + Concrete: 75,000 + Steel: 72,000 + Glass: 10,000)
static var FACTORY = {
	Goods.WOOD.name: 800,
	Goods.CONCRETE.name: 1500,
	Goods.STEEL.name: 1200,
	Goods.GLASS.name: 500,
}

# Total cost: 318,000 (Wood: 18,000 + Concrete: 125,000 + Steel: 150,000 + Glass: 25,000)
static var MEGAFACTORY = {
	Goods.WOOD.name: 1200,
	Goods.CONCRETE.name: 2500,
	Goods.STEEL.name: 2500,
	Goods.GLASS.name: 1250,
}

# Total cost: 217,500 (Concrete: 100,000 + Steel: 90,000 + Iron: 20,000 + Wood: 7,500)
static var LOGISTICS_HUB = {
	Goods.CONCRETE.name: 2000,
	Goods.STEEL.name: 1500,
	Goods.IRON.name: 1000,
	Goods.WOOD.name: 500,
}
