extends TileMapLayer

var tile_ownership = {}
# Assign some owners to tile positions. Each position stores an owner index (or id).

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.politicalmap = self
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_political_map():
	for position in GameState.provinces.keys():
		#set_cell_color(position.x, position.y, color)
		if GameState.provinces[position].owner != null:
			if GameState.provinces[position].terrain != "sea":
				set_cell(Vector2i(position),1,Vector2i(0,0))
				var tile_data = get_cell_tile_data(Vector2(position))
				_tile_data_runtime_update(position, tile_data )

# Set the modulate color for a tile in the political layer
func set_cell_color(x, y, color):
	set_cell(Vector2i(x,y),1,Vector2i(0,0))
	var tile = get_cell_tile_data(Vector2(x, y)) # Get the tile data from the political layer
	print(color)
	if tile:
		print(x,y,color)
		tile.set_modulate(color)
		print(tile.get_modulate())
		print(tile)

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return true

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	tile_data.modulate = GameState.provinces[coords].owner.map_color
