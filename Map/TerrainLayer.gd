extends TileMapLayer


var width = Defines.MAP_WIDTH
var height = Defines.MAP_HEIGHT

var tile_ids = {
	"land" = Vector2i(0,0),
	"sea" = Vector2i(6,0),
	"city" = Vector2i(0,1),
}

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Get the mouse position in the viewport
		

		var mouse_position = event.position
		if is_under_active_ui(mouse_position):
			return
		# Convert the mouse position to the global coordinate system of the TileMap
		var local_position = to_local(get_viewport().get_canvas_transform().affine_inverse() * mouse_position)
		
		# Convert the local position into TileMap coordinates
		var tile_position = local_to_map(local_position)
		tile_position = Vector2i(tile_position)
		if GameState.get_province(tile_position) != null:
			var clicked_tile_data = GameState.get_province(tile_position)
			GameState.map_cursor.highlight_selected_province(tile_position)
			#print("Clicked Tile Data: ID: ", clicked_tile_data.id, ", Type: ", clicked_tile_data.terrain, ", Population: ", clicked_tile_data.population)
			#print("Hex tile clicked: ", tile_position)
		else:
			pass
		
		# Output the hex coordinates (tile coordinates)
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		GameState.map_cursor.deselect_province()


func _ready():
	GameState.terrainmap = self
	var mapGeneratorInstance = Map_Generator.new()
	mapGeneratorInstance.generate_hex_grid(width,height,self)
	mapGeneratorInstance.generate_countries(self,8)
	mapGeneratorInstance.bfs_expansion()



func update_tile(location: Vector2, tile_key: String):
	set_cell(location,0,tile_ids[tile_key])


func is_under_active_ui(mouse_position):
	if %province_panel.get_global_rect().has_point(mouse_position) && (%province_panel.visible): 
		return true
	if %workplace_ui.get_global_rect().has_point(mouse_position) && (%workplace_ui.visible):
		return true
	return false
