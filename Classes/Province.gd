extends Resource
class_name Province 

var id: int
var location: Vector2i
var terrain: String
var population = 0
var pops = []
var development_level: int
var owner: Country
var birthrate: float = 0.02
var resource_potential = {}
var workplaces = {}
var market: Market

var development = {
	"0" = "empty",
	"1" = "settlement",
	"2" = "city",
	"3" = "estate",
	"4" = "metropolis"
}

func _init(id: int, terrain: String, development_level: int, location: Vector2i):
	self.id = id
	self.terrain = terrain
	self.development_level = development_level
	self.location = location
	if terrain == "land":
		self.market = Market.new(self)
		self.population = generate_population()
		workplaces[WP.SUBSITANCE] = Subsistance_Farm.new(self)

func create_city():
	development_level = 2
	GameState.terrainmap.update_tile(location, "city")
	workplaces[WP.LOGGING] = Logging_Camp.new(self)
	workplaces[WP.ARTISINAL] = Artisinal_Workshop.new(self)

	
func generate_population():
	var random_number = randi_range(3000,30000)
	return random_number
	
func get_population(): 
	var total_population = 0
	for pop in pops:
		print(pop.size)
		total_population += pop.size
	return total_population
		
