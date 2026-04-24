extends Resource
class_name Elite

const elite_types = [
	"family",
	"corporation",
	"political faction",
	"organized crime",
]

var name: String
var seat_of_power: Province
var type: String
var loyalty: int





#sources of power
var funds: float
var offices = {}
var ownership = {}
