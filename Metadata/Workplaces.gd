extends Resource
class_name WP

static var name = "name"
static var base_production = "base_production"
static var base_construction = "base_construction"
static var gpt_graphics_link = "https://chatgpt.com/share/6801371c-d5c0-8005-a7f5-09847f33f652"

static var SUBSISTANCE = {
	name:"Subsistance Farm",
	base_production: BP.SUBSISTANCE,
	base_construction: BC.RURAL,
	}

static var FARM = {
	name: "Commercial Farm",
	base_production: BP.FARM,
	base_construction:BC.RURAL,
}
static var LOGGING = {
	name: "Logging Industry",
	base_production: BP.LOGGING,
	base_construction: BC.RURAL,
}
static var STONE = {
	name: "Stone and Minerals Industry",
	base_production: BP.STONE,
	base_construction: BC.RURAL,
}

static var FURNITURE = {
	name: "Furniture Industry",
	base_production: BP.FURNITURE,
	base_construction: BC.WORKSHOP,
}

static var STEEL = {
	name: "Steel Industry",
	base_production: BP.FURNITURE,
	base_construction: BC.FACTORY,
}

static var TOOLS = {
	name: "Tooling Industry",
	base_production: BP.TOOLS,
	base_construction: BC.WORKSHOP,
}
static var TEXTILE = {
	name: "Textile Industry",
	base_production: BP.TEXTILE,
	base_construction: BC.WORKSHOP,
}

static var CLOTHING = {
	name: "Clothing Industry",
	base_production: BP.CLOTHING,
	base_construction: BC.WORKSHOP,
}

static var IRON = {
	name: "Iron Mine",
	base_production: BP.IRON,
	base_construction: BC.RURAL,
}

static var CONCRETE = {
	name: "Concrete Industry",
	base_production: BP.CONCRETE,
	base_construction: BC.WORKSHOP,
}

static var FOOD = {
	name: "Food Industry",
	base_production: BP.FOOD,
	base_construction: BC.WORKSHOP,
}

static var DISTILLERY = {
	name: "Alcohol Industry",
	base_production: BP.DISTILLERY,
	base_construction: BC.WORKSHOP,
}

static var TOBACCO = {
	name: "Tobacco Plantation",
	base_production: BP.TOBACCO,
	base_construction: BC.RURAL,
}

static var TEA = {
	name: "Tea Plantation",
	base_production: BP.TEA,
	base_construction: BC.RURAL,
}

static var COFFEE = {
	name: "Coffee Plantation",
	base_production: BP.COFFEE,
	base_construction: BC.RURAL,
}

static var GLASS = {
	name: "Glass Industry",
	base_production: BP.GLASS,
	base_construction: BC.WORKSHOP,
}

static var PAPER = {
	name: "Paper Industry",
	base_production: BP.PAPER,
	base_construction: BC.FACTORY,
}

static var PRINTING = {
	name: "Publishing Industry",
	base_production: BP.PRINT,
	base_construction: BC.WORKSHOP,
}

static var MACHINERY = {
	name: "Machinery Industry",
	base_production: BP.MACHINERY,
	base_construction: BC.WORKSHOP,
}

# Add to the LIST
static var LIST = {
	SUBSISTANCE.name: SUBSISTANCE,
	FARM.name: FARM,
	LOGGING.name: LOGGING,
	STONE.name: STONE,
	FURNITURE.name: FURNITURE,
	STEEL.name: STEEL,
	TOOLS.name: TOOLS,
	TEXTILE.name: TEXTILE,
	CLOTHING.name: CLOTHING,
	IRON.name: IRON,
	CONCRETE.name: CONCRETE,
	FOOD.name: FOOD,
	DISTILLERY.name: DISTILLERY,
	TOBACCO.name: TOBACCO,
	TEA.name: TEA,
	COFFEE.name: COFFEE,
	GLASS.name: GLASS,
	PAPER.name: PAPER,
	PRINTING.name: PRINTING,
	MACHINERY.name: MACHINERY,
}
