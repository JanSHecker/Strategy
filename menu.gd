extends NinePatchRect

func _ready() -> void:
	var create_map_button = $VBoxContainer/CreateMap
	var load_map_button = $VBoxContainer/LoadMap
	var terrain_button = $VBoxContainer/TerrainOnly
	
	create_map_button.connect("pressed",on_map_create_pressed)
	load_map_button.connect("pressed",on_load_map_pressed)
	terrain_button.connect("pressed", on_terrain_only_pressed)



func on_map_create_pressed():
	GameState.terrainmap.create_new_map()
	visible = false

func on_load_map_pressed():
	GameState.terrainmap.load_map()
	visible = false

func on_terrain_only_pressed():
	GameState.terrainmap.create_terrain_only()
	visible = false
