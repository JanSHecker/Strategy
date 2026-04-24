extends Node
class_name Region


var hub: String
var provinces: Array[String] = []
var border_provinces: Array[String] = []
var country:String
var id:String
var neighbors: Array[String] = []

var area: Polygon2D


var pops = {}
var wages = {}

var workplaces = {}
var constructions = []

#Transport Infrastructure
var rail_capacity
var port_capacity
var local_distribution_capacity

var distribution_price_per_unit = 1


var surrounding_provinces
var region_spread: float

var border = Line2D

var market: Market

func _init(id: String) -> void:
	self.id = id
	self.market = Market.new(self)
	self.pops[Poptypes.UNEMPLOYED.name] = Pop.new(generate_population(),Poptypes.UNEMPLOYED,self)
	self.workplaces[WP.SUBSISTANCE.name] = Workplace.new(self,WP.SUBSISTANCE,15)
	self.workplaces[WP.FARM.name] = Workplace.new(self,WP.FARM,5)
	self.workplaces[WP.LOGGING.name] = Workplace.new(self,WP.LOGGING,1)
	self.workplaces[WP.TEXTILE.name] = Workplace.new(self,WP.TEXTILE,1)
	self.workplaces[WP.FOOD.name] = Workplace.new(self,WP.FOOD,1)
	#self.workplaces[WP.FURNITURE.name] = Workplace.new(self,WP.FURNITURE,1)
	if id == "50":
		self.workplaces[WP.FURNITURE.name] = Workplace.new(self,WP.FURNITURE,10)
		self.workplaces[WP.LOGGING.name] = Workplace.new(self,WP.LOGGING,5)
		self.workplaces[WP.STONE.name] = Workplace.new(self,WP.STONE,5)
	self.wages = initialize_wages()




func initialize_wages():
	var wages = {}
	for type in Poptypes.poptype_list.values():
		wages[type.name] = type.base_wage
	return wages
	
func get_neighbors() -> Array[String]:
	#check if we already have calculated the neighbors
	if neighbors.size() > 0:
		return neighbors
	var surrounding_provinces = {}
	for province_id in provinces:
		var province = GameState.provinces.get(province_id)
		var new_surrounds = GameState.terrainmap.get_surrounding_cells(province.location)
		for location in new_surrounds:
			var potential_province_id = GameState.locations.get(location)
			if not surrounding_provinces.has(location) and not provinces.has(potential_province_id):
				surrounding_provinces[potential_province_id] = potential_province_id
				add_border_province(province.id)
	for province_id in surrounding_provinces:
		if GameState.provinces.has(province_id):
			var province = GameState.provinces.get(province_id)
			var region_id = province.region
			if not province.region:
				continue
			if region_id != self.id and not neighbors.has(region_id):
				neighbors.append(region_id)
	self.surrounding_provinces = surrounding_provinces
	return neighbors
	
func generate_population():
	var random_number = randi_range(300_000,3_000_000)
	return random_number
	
func get_population(): 
	var total_population = 0
	for pop in pops.values():
		total_population += pop.size
	total_population = float(total_population)
	return total_population

func build_workplace(workplace: String):
	self.workplaces[workplace] = Workplace.new(self,WP.LIST[workplace],0)
	UI.update_region_panel()

func add_construction(structure: Structure, owner: Dictionary):
	var new_construction = Construction.new(
		structure,
		owner[Ownership.owner_dict.TYPE],
		owner[Ownership.owner_dict.OBJECT],
		)
	constructions.append(new_construction)

func remove_construction(construction: Construction):
	constructions.erase(construction)
	UI.update_region_panel()


func add_border_province(province_id: String):
	if not border_provinces.has(province_id):
		border_provinces.append(province_id)

func measure_border(country: Country):
	var bordering_pronvinces: Array[String] = []
	for region_id in country.regions:
		var region = GameState.regions.get(region_id)
		bordering_pronvinces.append_array(region.get_border_provinces())
	var number_of_bordering_provinces = 0
	for border_province_id in bordering_pronvinces:
		for own_province_id in self.provinces:
			var own_province = GameState.provinces.get(own_province_id)
			if own_province.is_neighbor(border_province_id):
				number_of_bordering_provinces += 1
				break
	return number_of_bordering_provinces
		

func get_border_provinces() -> Array[String]:
	if border_provinces != []:
		return border_provinces
	for province_id in provinces:
		var province = GameState.provinces.get(province_id)
		#Identify all locations bordering a local province
		var neighbor_locations: Array[Vector2i] = GameState.terrainmap.get_surrounding_cells(province.location)
		for location in neighbor_locations:
			#filter out locations where no province is located
			if not GameState.locations.has(location):
				continue
			var neighbor_province_id = GameState.locations.get(location)
			#Filter provinces that are part of this region
			if provinces.has(neighbor_province_id):
				continue
			# if we are ever here there exists a province that is neighboring one of this regions provinces and is not part of this region => The original province of this region is a border province 
			add_border_province(province_id)
			break
	return border_provinces
