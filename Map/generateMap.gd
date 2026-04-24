extends Resource
class_name Map_Generator

const TILESET_ID = 7
# Define the size of the landmass and noise influence
const LAND_RADIUS = 40       # Base radius for the island
const LAND_NOISE_SCALE = 0.1       # Scale of the noise to adjust land roughness
const LAND_NOISE_INTENSITY = 35    # Intensity of the land noise variation

# Forest noise parameters
const FOREST_NOISE_SCALE = 0.15    # Scale of the forest noise
const FOREST_DENSE_THRESHOLD = 0.25 # Higher threshold for dense forest
const FOREST_SPARSE_THRESHOLD = 0.1 # Lower threshold for sparse forest edges

# Elevation parameters
const ELEVATION_NOISE_SCALE = 0.05   # Scale of the elevation noise (hills/mountains)
const ELEVATION_MOUNTAIN_THRESHOLD = 0.4 # Mountain threshold, higher means more mountains
const ELEVATION_HILL_THRESHOLD = 0.15    # Hill threshold, higher means more hills

var land_noise = FastNoiseLite.new()
var forest_noise = FastNoiseLite.new()
var elevation_noise = FastNoiseLite.new()

var available_land_tiles = []

# Generate the hex grid based on noise
func generate_hex_grid(width: int, height: int, tilemap: TileMapLayer):
	# Configure land noise
	land_noise.seed = randi()
	land_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	land_noise.frequency = LAND_NOISE_SCALE
	
	# Configure forest noise
	forest_noise.seed = randi()
	forest_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	forest_noise.frequency = FOREST_NOISE_SCALE
	
	# Configure elevation noise for hills and mountains
	elevation_noise.seed = randi()
	elevation_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	elevation_noise.frequency = ELEVATION_NOISE_SCALE
	
	# Random seed for land generation
	land_noise.seed = randi()
	
	# Fill map with water
	for y in range(height):
		for x in range(width):
			tilemap.set_cell(Vector2i(x, y), TILESET_ID, Defines.terrains["0"].atlas)
	
	var center_x = width / 2
	var center_y = height / 2
	
	for y in range(height):
		for x in range(width):
			# Calculate the Cartesian distance from the center
			var distance = distance_to_center(x, y, center_x, center_y)
			
			# Get Perlin noise value for land edges
			var land_noise_value = land_noise.get_noise_2d(x, y) * LAND_NOISE_INTENSITY
			
			# Check if the tile is within the land area with noise variation
			if distance <= LAND_RADIUS + land_noise_value:
				# Set tile as land
				tilemap.set_cell(Vector2i(x, y), TILESET_ID, Defines.terrains["1"].atlas)
				
				# Get elevation value (used for hills and mountains)
				var elevation_value = elevation_noise.get_noise_2d(x, y)
				var forest_noise_value = forest_noise.get_noise_2d(x, y)
				
				# Check for mountains and hills based on elevation
				if elevation_value > ELEVATION_MOUNTAIN_THRESHOLD:
					tilemap.set_cell(Vector2i(x, y), TILESET_ID, Defines.terrains["6"].atlas)  # Mountain
				elif elevation_value > ELEVATION_HILL_THRESHOLD:
					tilemap.set_cell(Vector2i(x, y), TILESET_ID, Defines.terrains["4"].atlas)  # Hill
					if forest_noise_value > FOREST_DENSE_THRESHOLD:
						tilemap.set_cell(Vector2i(x, y), TILESET_ID, Defines.terrains["4"].atlas)  # Forest on hill
				else:
					# Flat land forests
					if forest_noise_value > FOREST_DENSE_THRESHOLD:
						tilemap.set_cell(Vector2i(x, y), TILESET_ID, Defines.terrains["2"].atlas)  # Dense forest
					elif forest_noise_value > FOREST_SPARSE_THRESHOLD:
						tilemap.set_cell(Vector2i(x, y), TILESET_ID, Defines.terrains["2"].atlas)  # Sparse forest
					else:
						# Track available land tiles
						available_land_tiles.append(Vector2i(x, y))
	
	# Create provinces
	for y in range(Defines.MAP_HEIGHT):
		for x in range(Defines.MAP_WIDTH):
			var position = Vector2i(x, y)
			var tile_type = Defines.get_Terrain_from_Atlas(GameState.terrainmap.get_cell_atlas_coords(position))
			GameState.add_province(position, str(y * Defines.MAP_WIDTH + x), 1, tile_type)
	
	print("Created %s Provinces" % [GameState.provinces.size()])

func distance_to_center(x: int, y: int, center_x: int, center_y: int) -> float:
	return sqrt(pow(x - center_x, 2) + pow(y - center_y, 2))

	
func generateRegions(tilemap: TileMapLayer, min_region_size: int, max_region_size: int):
	print("start generating regions")
	var land_provinces = GameState.provinces.values().filter(func(a): return Defines.terrains[a.terrain].terrain_name != "Ocean")
	var unassigned_provinces = land_provinces.duplicate()
	var region_id = 0
	var regions = {}

	while unassigned_provinces.size() > 0:
		var region_size = randi_range(min_region_size, max_region_size)
		var new_region = Region.new(str(region_id))
		regions[str(region_id)] = new_region
		var start_province = unassigned_provinces.pop_back()
		new_region.provinces.append(start_province.id)
		start_province.region = new_region.id
		new_region.hub = start_province.id
		var queue = [start_province]
		
		while queue.size() > 0 and new_region.provinces.size() < region_size:
			queue.shuffle()
			var province: Province = queue.pop_back()
			var neighbors = tilemap.get_surrounding_cells(province.location)
			var valid_neighbors = []
			for neighbor_coordinates in neighbors:
				if GameState.locations.has(neighbor_coordinates):
					var neighbor_id = GameState.locations.get(neighbor_coordinates)
					var neighbor_province = GameState.provinces.get(neighbor_id)
					if neighbor_province in unassigned_provinces:
						valid_neighbors.append(neighbor_province)

			# Priorisiere Nachbarn, die die Region kompakter machen
			valid_neighbors.sort_custom(func(a, b):
				var a_dist = _calculate_distance_to_region(a, new_region)
				var b_dist = _calculate_distance_to_region(b, new_region)
				return a_dist < b_dist
			)

			# Füge die besten Nachbarn hinzu
			for neighbor_province in valid_neighbors:
				if new_region.provinces.size() >= region_size:
					break
				new_region.provinces.append(neighbor_province.id)
				unassigned_provinces.erase(neighbor_province)
				neighbor_province.region = new_region.id
				queue.append(neighbor_province)

		region_id += 1

	# Kleine Regionen zusammenführen
	_merge_small_regions(regions, land_provinces, tilemap)

	GameState.regions = regions

func generate_regions_alternative(tilemap: TileMapLayer, number_of_provinces: int):
	var land_provinces = GameState.provinces.values().filter(func(a): return a.terrain.terrain_name != "Ocean")
	var unassigned_provinces = land_provinces.duplicate()
	var region_id = 0
	var regions = {}
	
		
	
# Hilfsfunktion: Abstand einer Provinz zur Region berechnen
func _calculate_distance_to_region(province: Province, region: Region):
	var min_distance = INF
	var cumulative_distance = 0
	for region_province_id in region.provinces:
		var region_province = GameState.provinces.get(region_province_id)
		cumulative_distance += abs(province.location.x - region_province.location.x) + abs(province.location.y - region_province.location.y)
	var avg_distance = cumulative_distance / len(region.provinces)
	return avg_distance


# Funktion: Kleine Regionen zusammenführen
func _merge_small_regions(regions, land_provinces, tilemap):
	print("Merging small regions")
	var small_regions = regions.values().filter(func(a): return a.provinces.size() < 6)
	print(small_regions)
	for region in small_regions:
		var neighbors = region.get_neighbors()
		var min_distance = INF
		var closest_region = null
		for neighbor in neighbors:
			var neighbor_region = regions.get(neighbor)
			var hub_province = GameState.provinces.get(region.hub)
			var new_distance = _calculate_distance_to_region(hub_province,neighbor_region)
			if min_distance > new_distance:
				min_distance = new_distance
				closest_region = neighbor_region
		if not closest_region:
			continue
		closest_region.provinces.append_array(region.provinces)
		for province_id in region.provinces:
			var province = GameState.provinces.get(province_id)
			province.region = closest_region.id
		regions.erase(region.id)

				
				
func is_position_valid(new_region: Region, existing_capital_regions: Array, min_distance: int) -> bool:
	for existing_region in existing_capital_regions:
		if region_is_neighbor(new_region, existing_region):
			return false
	return true
	
func generate_countries(tilemap: TileMapLayer, number_of_countries: int):
	var unassigned_regions = GameState.regions.values()
	unassigned_regions.shuffle()
	var capital_regions: Array = []
	var placed_capitals: int=0
	var min_distance = 2
	while placed_capitals < number_of_countries:
		var candidate_region =  unassigned_regions.pop_back()
		if is_position_valid(candidate_region, capital_regions, min_distance):
			# Place the city on the map
			var country_id = str(placed_capitals)
			GameState.create_country(country_id, "country " + str(placed_capitals))
			capital_regions.append(candidate_region)
			placed_capitals += 1
			GameState.countries[country_id].annex_region(candidate_region.id)
			GameState.countries[country_id].capital_region = candidate_region.id

func region_is_neighbor(region_a, region_b):
	if region_a != null:
		for province_id in region_a.provinces:
			var province = GameState.provinces[province_id]
			var neighboring_provinces = GameState.terrainmap.get_surrounding_cells(province.location)
			for neighbor in neighboring_provinces:
				if neighbor in GameState.provinces.keys():
					if GameState.provinces[neighbor].region == region_b:
						return true
					
		return false

func find_unassigned_neighbor(country: Country, unassigned_regions: Array):
	var result := []
	for region_id in country.neighboring_regions:
		var region = GameState.regions.get(region_id)
		if unassigned_regions.has(region_id) and region.measure_border(country) >= 5:
			return region_id


func country_expansion():
	print("start country expansion using Algorithm 1")
	var unassigned_regions = GameState.regions.keys()
	# Remove already assigned regions
	for country in GameState.countries.values():
		for region in country.regions:
			unassigned_regions.erase(region)

	var unassigned_in_last_round := 0

	while unassigned_regions.size() > 0 and unassigned_in_last_round != unassigned_regions.size():
		unassigned_in_last_round = unassigned_regions.size()

		for country in GameState.countries.values():
			var neighbor = find_unassigned_neighbor(country, unassigned_regions)
			if neighbor:
				unassigned_regions.erase(neighbor)
				country.annex_region(neighbor)
				print(unassigned_regions.size())
	assign_leftover_regions(unassigned_regions)
	
	
	
func assign_leftover_regions(leftover_regions: Array):
	for region_id in leftover_regions:
		for country in GameState.countries.values():
			if country.neighboring_regions.has(region_id):
				country.annex_region(region_id)
				continue
	

func country_expansion_2():
	print("start country expansion using Algorithm 2")
	var unassigned_regions = GameState.regions.values()
	var counter = unassigned_regions.size()
	for country in GameState.countries.values():
		var starting_region = country.regions.get(0)
		unassigned_regions.erase(starting_region)
	for region in unassigned_regions:
		var closest_country: Country
		var closest_distance = INF
		for country in GameState.countries.values():
			var distance = get_distance_to_country(region,country)
			if  distance < closest_distance:
				closest_country = country
				closest_distance = distance
		closest_country.annex_region(region)
		counter -= 1 
		
func get_distance_to_country(region, country):
	var main_region = country.regions.get(0)
	var rand = randi_range(0,region.provinces.size() - 1)
	var random_province = region.provinces[rand]
	return _calculate_distance_to_region(random_province,main_region)
