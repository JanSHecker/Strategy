extends Node2D

const REGION_BORDER_WIDTH = 8.0
const COUNTRY_BORDER_WIDTH = 16.0
const region_border_color = Color(0.3,0.3,0.3,0.9)
const selected_region_color = Color(0.7,0.7,0.7,0.9) #grey

func update_borders():
	
	for region_id in GameState.regions:
		draw_region_border(region_id)
	
	
	for country_id in GameState.countries:
		draw_country_border(country_id)

func select_region(region_id: String):
	if not region_id:
		return
	if GameState.selected_region:
		deselect_region()
	var region = GameState.regions.get(region_id)
	UI.update_build_panel(region)
	GameState.selected_region = region.id
	%Region_Panel.enable()
	UI.update_region_panel()
	region.border.self_modulate = selected_region_color
	region.border.width = 16.0
	region.border.z_index = region.border.z_index + 100
	
func deselect_region():
	if GameState.selected_region == null:
		return
	var region_id = GameState.selected_region
	var region = GameState.regions.get(region_id)
	GameState.selected_region = null
	%Region_Panel.disable()
	region.border.self_modulate = region_border_color
	region.border.width = REGION_BORDER_WIDTH
	region.border.z_index = region.border.z_index - 100

func draw_region_border(region_id: String):
	var border = Line2D.new()
	border.self_modulate = region_border_color
	var region = GameState.regions[region_id]
	for province_id in region.provinces:
		var province = GameState.provinces[province_id]
		var vertices: PackedVector2Array = province.get_vertices()
		var res = Geometry2D.merge_polygons(border.points,vertices)
		border.points = res[0]
	border.closed = true
	border.width = REGION_BORDER_WIDTH
	region.border = border
	self.add_child(border)

func draw_country_border(country_id: String):
	var country = GameState.countries.get(country_id)
	var border = Line2D.new()
	border.self_modulate = country.map_color
	var merged_points = []

	for region_id in country.regions:
		var region = GameState.regions[region_id]
		var res = Geometry2D.merge_polygons(merged_points, region.border.points)
		if res.size() > 0:
			merged_points = res[0]

	# Offset the polygon inwards
	var offset_result = Geometry2D.offset_polygon(merged_points, -8.0) # Negative for inward offset
	if offset_result.size() > 0:
		border.points = offset_result[0] # Use the first offset shape

	border.closed = true
	border.width = COUNTRY_BORDER_WIDTH
	border.z_index += 10
	country.border = border
	self.add_child(border)
