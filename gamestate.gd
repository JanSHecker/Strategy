#gamestate.gd
extends Node


var countries = {}
var provinces = {}
var terrainmap: TileMapLayer
var politicalmap: TileMapLayer
var map_cursor: TileMapLayer

var pop_register = []
var workplace_register = []

var workplace_ui

func create_country(country_id: String, name: String):
	countries[country_id] = (Country.new(country_id, name))
	
	
func _ready() -> void:
	pass

func get_province(tile_position: Vector2i) -> Variant:
	return provinces.get(tile_position, null)

func add_province(location: Vector2i, id: int, development_level: int, terrain: String):
	provinces[location] = Province.new(id,terrain, development_level, location)

#func populate_map():
	#var min = 100
	#var max = 3000
	#for location in provinces.keys():
		#if provinces[location].population == 0 && provinces[location].terrain == "land":
			#provinces[location].population = randi()% (max - min + 1) + min

func add_city(location: Vector2i):
	var province = provinces[location]
	province.development_level = 2
	province.population = randi()% (30000 - 10000 + 1) + 10000
	terrainmap.update_tile(location, "city")



#These blocs are executed periodically as long as game time passes
func daily_tick():
	pass
	
func weekly_tick():
	economy()
	workplace_ui.update_workplace_ui()
	employment()
	map_cursor.ui_panel.update_province_panel()
	
func monthly_tick():
	pop_growth()

func yearly_tick():
	pass


#Below are the different functions of the gameflow
func pop_growth():
	for pop in pop_register:
		pop.population_growth_tic()
	map_cursor.ui_panel.update_province_panel()
	
	
func economy():
	#order phase
	for workplace in workplace_register:
		workplace.send_order()
	#input phase
	for province in provinces.values():
		if province.market != null:
			province.market.resolve_demand()
	#output phase
	for workplace in workplace_register:
		workplace.throughput()

func employment():
	for workplace in workplace_register:
		if workplace.workplace_type != WP.SUBSITANCE:
			var missing_employment = workplace.get_missing_employment()
			if workplace.can_afford_wages(missing_employment):
				for poptype in missing_employment:
					workplace.employ(missing_employment[poptype], poptype)
			if workplace.has_no_workers():
				var base = workplace.base_employment_per_level
				for poptype in base:
					workplace.employ(base[poptype] / 10, poptype)
			
