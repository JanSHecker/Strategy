extends TileMapLayer


var width = Defines.MAP_WIDTH
var height = Defines.MAP_HEIGHT
@export var stateborders:Node
@export var region_panel: Node

const MIN_REGION_SIZE = 17
const MAX_REGION_SIZE = 25


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Get the mouse position in the viewport
		

		var mouse_position = event.position
		if UI.is_under_active_ui(mouse_position):
			return
		# Convert the mouse position to the global coordinate system of the TileMap
		var local_position = to_local(get_viewport().get_canvas_transform().affine_inverse() * mouse_position)
		
		# Convert the local position into TileMap coordinates
		var tile_position = local_to_map(local_position)
		tile_position = Vector2i(tile_position)
		var province_id = GameState.locations.get(tile_position)
		if province_id:
			var clicked_tile_province = GameState.provinces.get(province_id)
			if GameState.selected_region == clicked_tile_province.region:
				GameState.map_cursor.highlight_selected_province(tile_position)
			else:
				stateborders.select_region(clicked_tile_province.region)
				GameState.map_cursor.deselect_province()
			#print("Clicked Tile Data: ID: ", clicked_tile_data.id, ", Type: ", clicked_tile_data.terrain, ", Population: ", clicked_tile_data.population)
			#print("Hex tile clicked: ", tile_position)
		else:
			pass
		
		# Output the hex coordinates (tile coordinates)
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		GameState.map_cursor.deselect_province()
		stateborders.deselect_region()


func _ready():
	Consumption_Level.generate_consumption_levels()
	Consumption_Level.generate_survival_consumption_level()
	Consumption_Level.generate_life_consumption_level()
	Consumption_Level.generate_luxury_consumption_level()
	
	GameState.terrainmap = self


func update_tile(location: Vector2, tile_key: String):
	set_cell(location,1,Defines.terrains[tile_key].atlas)



	
	#if %province_panel.get_global_rect().has_point(mouse_position) && (%province_panel.visible):
		#return true
	#if %workplace_ui.get_global_rect().has_point(mouse_position) && (%workplace_ui.visible):
		#return true
	#if %Region_Panel.get_global_rect().has_point(mouse_position) && (%Region_Panel.visible):
		#return true
	#return false

func create_new_map():
	print("Create a new Map")
	var mapGeneratorInstance = Map_Generator.new()
	mapGeneratorInstance.generate_hex_grid(width,height,self)
	mapGeneratorInstance.generateRegions(self, MIN_REGION_SIZE, MAX_REGION_SIZE)
	mapGeneratorInstance.generate_countries(self,16)
	mapGeneratorInstance.country_expansion()
	MapSaver.save_map()
	setup()
	
func create_terrain_only():
	var mapGeneratorInstance = Map_Generator.new()
	mapGeneratorInstance.generate_hex_grid(width,height,self)

func load_map():
	print("load Map from Memory")
	MapSaver.load_map()
	setup()


func setup():
	stateborders.update_borders()
	GameState.select_random_player_country()
	#for country in GameState.countries.values():
		#country.clean_up_regions()
	GameState.transportation_network.create_adjacency_matrix()
	GameState.transportation_network.compute_all_pairs_shortest_paths()
