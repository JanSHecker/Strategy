extends Node

var MAP_HEIGHT = 120
var MAP_WIDTH = 260

const TILESET_ID = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

static var terrains = {
	"0": Terrain.new("Ocean", Vector2i(3,0)),
	"1": Terrain.new("Plains",Vector2i(0,0)),
	"2": Terrain.new("Light Forest",Vector2i(5,0)),
	"3": Terrain.new("Dense Forest", Vector2i(4,0)),
	"4": Terrain.new("Hills",Vector2i(1,0)),
	"5": Terrain.new("Forest Hills", Vector2i(0,10)),
	"6": Terrain.new("Mountain", Vector2i(2,0)),
	"7": Terrain.new("City", Vector2i(2,8))
}
func get_Terrain_from_Atlas(atlas: Vector2i):
	for terrain in terrains:
		if terrains[terrain].atlas == atlas:
			return terrain

enum OwnershipTypes {
	COOP,
	ARTISINAL,
	PRIVATE,
	PUBLIC,
}
