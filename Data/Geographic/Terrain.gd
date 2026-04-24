extends Node
class_name Terrain


var terrain_name: String
var atlas: Vector2i

func _init(tname: String, atlas:Vector2i) -> void:
	self.terrain_name = tname
	self.atlas = atlas
