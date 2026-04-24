extends Resource
class_name Goods
const cat_staple = "staple"
const cat_industrial = "industrial"
const cat_luxury = "luxury"
const cat_military = "military"
const cat_consumer = "consumer"

const name = "name"
const type = "type"
const price = "baseprice"

static var GRAIN = Good.new(
	"Grain",
	cat_staple,
	10.0,
	0.5
)
static var MEAT = Good.new(
	"Meat",
	cat_luxury,
	20.0,
	1.0
)
static var GROCERIES = Good.new(
	"Groceries",
	cat_consumer,
	20.0,
	0.8
)
static var DELICACIES = Good.new(
	"Delicacies",
	cat_luxury,
	50.0,
	0.3
)
static var WOOD = Good.new(
	"Wood",
	cat_staple,
	15.0,
	2.0
)
static var ALCOHOL = Good.new(
	"Alcohol",
	cat_staple,
	10.0,
	0.6
)
static var TOBACCO = Good.new(
	"Tobacco",
	cat_staple,
	10.0,
	0.4
)
static var TEA = Good.new(
	"Tea",
	cat_luxury,
	30.0,
	0.2
)
static var COFFEE = Good.new(
	"Coffee",
	cat_luxury,
	30.0,
	0.3
)
static var STONE = Good.new(
	"Stone",
	cat_industrial,
	10.0,
	5.0
)
static var GLASS = Good.new(
	"Glass",
	cat_industrial,
	20.0,
	5.0
)
static var COAL = Good.new(
	"Coal",
	cat_industrial,
	20.0,
	3.5
)
static var CONCRETE = Good.new(
	"Concrete",
	cat_industrial,
	50.0,
	3.0
)
static var IRON = Good.new(
	"Iron",
	cat_industrial,
	20.0,
	4.0
)
static var STEEL = Good.new(
	"Steel",
	cat_industrial,
	60.0,
	6.0
)
static var FABRIC = Good.new(
	"Fabric",
	cat_staple,
	20.0,
	0.5
)
static var CLOTHING = Good.new(
	"Clothing",
	cat_consumer,
	40.0,
	0.7
)
static var FURNITURE = Good.new(
	"Furniture",
	cat_consumer,
	40.0,
	3.0
)
static var PAPER = Good.new(
	"Paper",
	cat_industrial,
	30.0,
	1.0
)
static var PRINT_MEDIA = Good.new(
	"Print Media",
	cat_consumer,
	50.0,
	1.2
)
static var TOOLS = Good.new(
	"Tools",
	cat_industrial,
	40.0,
	2.5
)
static var MACHINERY = Good.new(
	"Machinery",
	cat_industrial,
	100.0,
	5.0
)

static var goods_list = {
	GRAIN.name: GRAIN,
	MEAT.name:MEAT,
	GROCERIES.name:GROCERIES,
	DELICACIES.name:DELICACIES,
	WOOD.name: WOOD,
	ALCOHOL.name:ALCOHOL,
	TOBACCO.name:TOBACCO,
	TEA.name:TEA,
	COFFEE.name:COFFEE,
	STONE.name: STONE,
	GLASS.name: GLASS,
	COAL.name: COAL,
	CONCRETE.name: CONCRETE,
	IRON.name: IRON,
	STEEL.name:STEEL,
	FABRIC.name:FABRIC,
	CLOTHING.name:CLOTHING,
	FURNITURE.name:FURNITURE,
	PAPER.name:PAPER,
	PRINT_MEDIA.name:PRINT_MEDIA,
	TOOLS.name:TOOLS,
	MACHINERY.name:MACHINERY,
}

static func get_dummy():
	var dummy = {}
	for good in goods_list:
		dummy[good] = 0
	return dummy
