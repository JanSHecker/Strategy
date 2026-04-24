extends Panel

@onready var tab_bar = $TabContainer
@onready var info_container = $TabContainer/Info
@onready var workplaces_container = $TabContainer/Workplaces
@onready var workplace_ui = %workplace_ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	tab_bar.mouse_filter = MOUSE_FILTER_IGNORE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func update_province_panel():
	if GameState.map_cursor.selected_province == null:
		return
	clear_province_panel()
	var province = GameState.map_cursor.selected_province
	
	
	
	#Info-panel
	var position = Button.new()
	var development = Button.new()
	var region = Button.new()
	var country = Button.new()
	position.text = "Hex selected at position: " + str(province.location)
	development.text = "Development Level: " + province.development[str(province.development_level)]
	info_container.add_child(position)
	info_container.add_child(development)
	if province.region != null:
		region.text = "Region ID: " + province.region
		if province.country != null:
			country.text = "Country ID: " + province.country
	info_container.add_child(country)
	info_container.add_child(region)
	var terrain = Defines.terrains.get(province.terrain)
	if terrain.terrain_name == "Ocean":
		return









func clear_province_panel():
	for child in tab_bar.get_children():
		for grandchild in child.get_children():
			grandchild.queue_free()


#handle enabling and diabling of the UI
func enable():
	visible = true
	mouse_filter = MOUSE_FILTER_STOP
	tab_bar.mouse_filter = MOUSE_FILTER_STOP
	update_province_panel()
	
func disable():
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
	tab_bar.mouse_filter = MOUSE_FILTER_IGNORE
