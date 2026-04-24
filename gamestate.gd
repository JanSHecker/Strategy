#gamestate.gd
extends Node

var grid:TileMapLayer
var countries = {}
var regions = {}
var provinces = {}
var locations = {}


var terrainmap: TileMapLayer
var politicalmap: TileMapLayer
var map_cursor: TileMapLayer
var player_country_id: String
var economic_system
var transportation_network = TransportationNetwork.new()

var pop_register = []
var workplace_register = []

var workplace_ui
var country_panel

var selected_provice
var selected_region

func create_country(country_id: String, name: String):
	countries[country_id] = (Country.new(country_id, name))
	
	
func _ready() -> void:
	pass

func get_province(tile_position: Vector2i) -> Variant:
	return provinces.get(tile_position, null)

func add_province(location: Vector2i, id: String, development_level: int, terrain: String):
	provinces[id] = Province.new(id,terrain, development_level, location)
	locations[location] = id

func add_city(location: Vector2i):
	var province = provinces[location]
	province.development_level = 2
	province.population = randi()% (30000 - 10000 + 1) + 10000
	terrainmap.update_tile(location, "city")



#These blocs are executed periodically as long as game time passes
func daily_tick():
	pass
	
func weekly_tick():
	await economic_system.econmic_cycle()
	employment()
	
	
func monthly_tick():
	pop_growth()

func yearly_tick():
	pass


#Below are the different functions of the gameflow
func pop_growth():
	for pop in pop_register:
		pop.population_growth_tic()
	map_cursor.ui_panel.update_province_panel()
	
	


func employment():
	for region in regions.values():
		for workplace in region.workplaces.values():
			var missing_employment = workplace.get_missing_employment()
			for poptype in missing_employment:
				if missing_employment[poptype] >= 0:
					var amount = max(missing_employment[poptype] / 10, min(30,missing_employment[poptype]))
					workplace.employ(int(amount), poptype)
				else:
					var amount = -1 * missing_employment[poptype]
					workplace.fire(int(amount),poptype)
			if workplace.has_no_workers():
				var base = workplace.desired_employment
				for poptype in base:
					workplace.employ(base[poptype] / 10, poptype)



func select_random_player_country():
	var rand = randi_range(0,countries.size()-1)
	set_player_country(str(rand))
	politicalmap.update_political_map()
	
	
func set_player_country(country_id: String):
	if countries.keys().has(country_id):
		player_country_id = country_id
		UI.update_country_overview()
