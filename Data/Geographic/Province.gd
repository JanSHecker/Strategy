extends Resource
class_name Province 

var id: String
var location: Vector2i
var terrain: String
var pops = []
var development_level: int
var market: Market
var region: String
var vertices = []
var country: String

var development = {
	"0" = "empty",
	"1" = "settlement",
	"2" = "city",
	"3" = "estate",
	"4" = "metropolis"
}

func _init(id: String, terrain_id: String, development_level: int, location: Vector2i):
	self.id = id
	self.terrain = terrain_id
	self.development_level = development_level
	self.location = location


func get_vertices():
	var tilemap = GameState.terrainmap
	var center = tilemap.map_to_local(location)
	var radius = 128.5
	
	for i in range(6):
		var angle = deg_to_rad(i * 60) # 60 degrees between each vertex
		var x = center.x + radius * cos(angle)
		var y = center.y + radius * sin(angle)
		vertices.append(Vector2(x, y))
	return vertices

func get_population():
	return 0
	
func is_neighbor(potential_neighbor_id: String) -> bool:
	if not GameState.provinces.has(potential_neighbor_id):
		return false
	var map = GameState.terrainmap
	var potential_neighbor = GameState.provinces.get(potential_neighbor_id)
	var neighbors: Array[Vector2i] = map.get_surrounding_cells(potential_neighbor.location)
	return neighbors.has(self.location)
