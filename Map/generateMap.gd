extends Resource
class_name Map_Generator




# Generate the hex grid based on noise
func generate_hex_grid(width: int, height:int, tilemap: TileMapLayer):
	var noise := FastNoiseLite.new()
	var noise_scale: float = 0.1   # Scaling factor for noise (controls detail level)
	var land_threshold: float = -0.2 # Threshold value for land tiles (FastNoiseLite returns values [-1, 1])
	noise.seed = randi()  # Random seed for noise generation
	noise.frequency = 0.5  # Frequency of the noise (lower means larger features)
	for y in range(height):
		for x in range(width):
			

			# Get noise value for each tile (FastNoiseLite returns values in the range [-1, 1])
			var noise_value = noise.get_noise_2d(x * noise_scale, y * noise_scale)

			# Classify tile as land or water based on the threshold
			if noise_value > land_threshold:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(0,0))  # Set land tile
				GameState.add_province(Vector2(x,y),y * width + x, 1, "land")
				
			else:
				tilemap.set_cell(Vector2i(x,y),0,Vector2i(6,0))  # Set water tile
				GameState.add_province(Vector2(x,y),y * width + x, 0, "sea")

func generate_cities(tilemap: TileMapLayer,number_of_cities: int):
	var city_positions: Array = []
	var placed_cities: int = 0
	var width = 29
	var height = 29
	var min_distance = 4
	while placed_cities < number_of_cities:
		var new_position = Vector2(randi_range(0, width), randi_range(0, height))
		
		if is_position_valid(new_position, city_positions, min_distance):
			# Place the city on the map
			tilemap.set_cell(new_position,0,Vector2i(0,1))
			GameState.add_city(new_position)
			city_positions.append(new_position)
			GameState.create_country("1", "Mangaelstein")
			placed_cities += 1
		# If the position is not valid, try another position

func is_position_valid(new_position: Vector2i, existing_positions: Array, min_distance: int) -> bool:
	if GameState.provinces[new_position].terrain == "sea":
		return false
	for pos in existing_positions:
		if new_position.distance_to(pos) < min_distance:
			return false
	return true
	
	
	
func generate_countries(tilemap: TileMapLayer, number_of_countries: int):
	var capital_positions: Array = []
	var placed_capitals: int=0
	var min_distance = 7
	while placed_capitals < number_of_countries:
		var new_position = Vector2i(randi_range(2, tilemap.width - 3), randi_range(2, tilemap.height - 3))
		
		if is_position_valid(new_position, capital_positions, min_distance):
			# Place the city on the map
			var country_id = str(placed_capitals)
			GameState.create_country(country_id, "country " + str(placed_capitals))
			GameState.provinces[new_position].create_city()
			capital_positions.append(new_position)
			placed_capitals += 1
			
			GameState.countries[country_id].annex_province(new_position)


func bfs_expansion():
	# Directions for flat-topped hexes in a diamond-down layout
	var directions = [
		Vector2i(-1, -1),  # North
		Vector2i(1, 1),    # South
		Vector2i(0, -1),   # North-East
		Vector2i(-1, 0),   # North-West
		Vector2i(0, 1),    # South-East
		Vector2i(1, 0)     # South-West
	]
	
	# Initialize BFS queues
	var queues = {}
	for country in GameState.countries.values():
		queues[country] = []
		# Add all owned provinces to the BFS queue
		for province in country.owned_provinces:
			queues[country].append(province.location)
	
	# Continue expanding until no country can expand
	while true:
		var any_expansion = false  # Track if any country expanded this round
		var next_queues = {}  # Store the next state of queues
		
		# Process each country's queue
		for country in GameState.countries.values():
			if not queues.has(country):
				continue
			
			var queue = queues[country]
			next_queues[country] = []
			
			while not queue.is_empty():
				var current_location = queue.pop_front()
				
				# Check all 6 hex neighbors
				for direction in directions:
					var neighbor_location = current_location + direction
					if GameState.provinces.has(neighbor_location):
						var province = GameState.provinces[neighbor_location]
						
						# If the neighbor province is unclaimed, claim it
						if province.owner == null:
							country.annex_province(province.location)
							next_queues[country].append(neighbor_location)
							any_expansion = true
		
		# Update the queues for the next round
		queues = next_queues
		
		# If no country expanded, break the loop
		if not any_expansion:
			break
