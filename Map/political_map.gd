extends TileMapLayer

var tile_ownership = {}
const NON_PLAYER_COLOR = Color(0,0,0,0.6)
# Assign some owners to tile positions. Each position stores an owner index (or id).

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.politicalmap = self
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_political_map():
	for province_id in GameState.provinces:
		var province = GameState.provinces[province_id]
		if province.country:
			set_cell(province.location,1,Vector2i(0,0))
			var tile_data = get_cell_tile_data(province.location)
			_tile_data_runtime_update(province.location, tile_data )

# Set the modulate color for a tile in the political layer
func set_cell_color(x, y, color):
	set_cell(Vector2i(x,y),1,Vector2i(0,0))
	var tile = get_cell_tile_data(Vector2(x, y)) # Get the tile data from the political layer
	if tile:
		tile.set_modulate(color)


func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return true

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	var player_country_id = GameState.player_country_id
	var tile_province_id = GameState.locations[coords]
	var province = GameState.provinces.get(tile_province_id)
	if not player_country_id:
		return
	if player_country_id == province.country:
		tile_data.modulate = Color(0,0,0,0)
	else:
		tile_data.modulate = NON_PLAYER_COLOR
