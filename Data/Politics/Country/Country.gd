extends Resource
class_name Country

var id: String
var name: String
var map_color: Color
var border: Line2D
var owned_provinces: Array[String] = []
var regions: Array[String] = []
var capital_region: String
var neighboring_regions: Array[String] = []


#Modules
var finances = Finances.new()
var private_investment = PrivateInvestment.new(self)

var tax_code = {
	"per_capita": 0.01,
	"income": 0.1,
	"profit": 0.1,
}
var prestige: int


func _init(country_id: String, name: String):
	self.id = country_id
	self.name = name
	self.map_color = get_unique_color(country_id)


func get_unique_color(country_id: String) -> Color:
	var unique_color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1), 0.8) 
	return unique_color


func annex_province(province_id: String):
	owned_provinces.append(province_id)
	GameState.provinces[province_id].country = id
	GameState.politicalmap.update_political_map()
	
func annex_region(region_id: String, trackNeighbors: bool = true):
	var region = GameState.regions[region_id]
	region.country = id
	regions.append(region_id)
	for province_id in region.provinces:
		annex_province(province_id)
	if not trackNeighbors:
		return
	neighboring_regions.erase(region_id)
	var new_neighbors = region.get_neighbors()
	for potential_neighbor_id in new_neighbors:
		if not neighboring_regions.has(potential_neighbor_id) and not regions.has(potential_neighbor_id):
			neighboring_regions.append(potential_neighbor_id)


func clean_up_regions():
	for region_id in regions:
		var counter = 0
		var region = GameState.regions[region_id]
		for province_id in region.surrounding_provinces:
			if owned_provinces.has(province_id):
				counter += 1
		if counter <= 4:
			region.owning_country = null
			
