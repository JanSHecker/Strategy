extends Resource
class_name Country

var country_id: String
var name: String
var map_color: Color
var owned_provinces: Array[Province] = []

func _init(country_id: String, name: String):
	self.country_id = country_id
	self.name = name
	self.map_color = get_unique_color(country_id)






# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Method to generate a unique color based on the country ID
func get_unique_color(country_id: String) -> Color:
	# Convert the country ID to a hash value
	var unique_color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1), 0.6) 
	
	# Generate a color from the normalized hash value
	return unique_color

# Helper function to compute a hash value from a string
#func hash(s: String) -> int:
	#var hash = 5381
	#for i in range(s.length()):
		#var char = s[i]
		#hash = ((hash << 5) + hash) + char.ascii_code()  # hash * 33 + c
	#return hash


func annex_province(position: Vector2i):
	var province = GameState.provinces[position]
	owned_provinces.append(province)
	province.owner = self
	GameState.politicalmap.update_political_map()
	
