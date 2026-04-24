extends Node
class_name MapSaver

const PROVINCES = "Provinces"
const REGIONS = "Regions"
const COUNTRIES = "Countries"

const filepath = "res://Saved_Maps/map.json"

static func save_map():
	var map = {
		PROVINCES: [],
		REGIONS: [],
		COUNTRIES: [],
	}
	for province in GameState.provinces.values():
		var province_save = {
			"id": province.id,
			"region": province.region,
			"country": province.country,
			"x": province.location.x,
			"y": province.location.y,
			"terrain": province.terrain,
		}
		map[PROVINCES].append(province_save)
	for region in GameState.regions.values():
		var state_save = {
			"id": region.id,
			"country": region.country,
			"hub": region.hub,
			"provinces": region.provinces
		}
		map[REGIONS].append(state_save)
	for country in GameState.countries.values():
		var country_save = {
			"id": country.id,
			"color": country.map_color.to_html(),
			"capital": country.capital_region,
			"states": country.regions,
			"provinces": country.owned_provinces,
			"neighbors": country.neighboring_regions,
		}
		map[COUNTRIES].append(country_save)
	var map_string = JSON.stringify(map,"\t")
	
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	if file:
		file.store_string(map_string)
		file.close()
		print("Data saved to JSON.")
	else:
		print("Failed to open file for writing.")

static func load_map():
	if not FileAccess.file_exists(filepath):
		print("Save file not found.")
		return
	
	var file = FileAccess.open(filepath, FileAccess.READ)
	if not file:
		print("Failed to open file for reading.")
		return
	
	var map_string = file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(map_string)
	if result == null:
		print("Failed to parse JSON.")
		return
	
	# Clear existing state

	var provinces_data = result[PROVINCES]
	var regions_data = result[REGIONS]
	var countries_data = result[COUNTRIES]

	# Load provinces
	for province_data in provinces_data:
		var id = province_data["id"]
		var x = province_data["x"]
		var y = province_data["y"]
		var region = province_data["region"]
		var country = province_data["country"]
		var terrain = province_data["terrain"]
		var location = Vector2i(x, y)
		GameState.terrainmap.set_cell(location,Defines.TILESET_ID,Defines.terrains[terrain].atlas)
		
		var province = Province.new(id, terrain, 1, location) 
		province.region = region
		province.country = country 
		GameState.provinces[id] = province
		GameState.locations[location] = id
	
	# Load regions
	for region_data in regions_data:
		var region_id = region_data["id"]
		var hub_id = region_data["hub"]
		var country = region_data["country"]
		var province_ids = region_data["provinces"]
		
		var region = Region.new(region_id)  # Adjust constructor if needed
		region.hub = hub_id
		region.provinces.append_array(province_ids)
		region.country = country
		GameState.regions[region_id] = region
	
	# Load countries
	for country_data in countries_data:
		var country_id = country_data["id"]
		var color = Color.html(country_data["color"])
		var capital_id = country_data["capital"]
		var region_ids = country_data["states"]
		var province_ids = country_data["provinces"]
		var neighbors = country_data["neighbors"]
		
		var country = Country.new(country_id,"Country " + country_id)  # Adjust constructor if needed
		country.map_color = color
		country.capital_region = capital_id
		country.regions.append_array(region_ids)
		country.owned_provinces.append_array(province_ids)
		country.neighboring_regions.append_array(neighbors)
		GameState.countries[country_id] = country


	
	print("Map loaded successfully.")

	
	
