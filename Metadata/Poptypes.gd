extends Resource
class_name Poptypes



static var UNEMPLOYED = Poptype.new("unemployed", 0)  # No job, no income
static var PEASANT = Poptype.new("peasant", 0)  # Subsistence farmer, no wage
static var LABORER = Poptype.new("laborer", 1)  # Unskilled manual worker
static var FARMHAND = Poptype.new("farmhand", 1)  # Agricultural laborer
static var FARMER = Poptype.new("farmer", 2)  # Landowning agricultural worker
static var TECHNICIAN = Poptype.new("technician", 2)  # Skilled industrial worker
static var CLERK = Poptype.new("clerk", 2)  # Office or administrative worker
static var SOLDIER = Poptype.new("soldier", 2)  # Enlisted military personnel
static var ARTISAN = Poptype.new("artisan", 3)  # Skilled craftsman or tradesperson
static var MERCHANT = Poptype.new("merchant", 3)  # Trader or business owner
static var BUREAUCRAT = Poptype.new("bureaucrat", 4)  # Government administrator
static var OFFICER = Poptype.new("officer", 6)  # Military commander or officer
static var ENGINEER = Poptype.new("engineer", 6)  # Technical professional
static var ACADEMIC = Poptype.new("academic", 6)  # Scholar, scientist, or educator
static var ARISTOCRAT = Poptype.new("aristocrat", 8)  # Landowning noble elite
static var RESOURCE_BARON = Poptype.new("resource_baron", 8)  # Owner of natural resource extraction
static var CAPITALIST = Poptype.new("capitalist", 8)  # Industrial or financial magnate


static var poptype_list = {
	"unemployed": UNEMPLOYED,
	"peasant": PEASANT,
	"laborer": LABORER,
	"farmhand": FARMHAND,
	"farmer": FARMER,
	"technician": TECHNICIAN,
	"clerk": CLERK,
	"soldier": SOLDIER,
	"bureaucrat": BUREAUCRAT,
	"artisan": ARTISAN,
	"merchant": MERCHANT,
	"officer": OFFICER,
	"engineer": ENGINEER,
	"academic": ACADEMIC,
	"aristocrat": ARISTOCRAT,
	"resource_baron": RESOURCE_BARON,
	"capitalist": CAPITALIST,
}
