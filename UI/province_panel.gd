extends Panel

@onready var tab_bar = $TabContainer
@onready var info_container = $TabContainer/Info
@onready var population_container = $TabContainer/Population
@onready var workplaces_container = $TabContainer/Workplaces
@onready var market_container = $TabContainer/Market
@onready var workplace_ui = %workplace_ui

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	$TabContainer.mouse_filter = MOUSE_FILTER_IGNORE


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
	position.text = "Hex selected at position: " + str(province.location)
	development.text = "Development Level: " + province.development[str(province.development_level)]
	info_container.add_child(position)
	info_container.add_child(development)
	
	if province.terrain == "sea":
		return

	#Workplace-panel
	for key in province.workplaces:
		var button = Button.new()
		button.text = province.workplaces[key].workplace_type
		button.focus_mode = Control.FOCUS_NONE
		button.connect("pressed", Callable(workplace_ui, "_on_building_selected").bind(province.workplaces[key]))
		workplaces_container.add_child(button)

	#Population-panel
	var label = Button.new()
	label.text = "Total Population: " + str(province.get_population())
	population_container.add_child(label)
	
	for pop in province.pops:
		var hcontainer = HBoxContainer.new()
		
		var size = Button.new()
		size.text = str(pop.size)
		hcontainer.add_child(size)
		
		var workplace = Button.new()
		workplace.text = str(pop.workplace.workplace_type)
		hcontainer.add_child(workplace)
		
		population_container.add_child(hcontainer)
	
	#Market-panel
	for stock in province.market.resource_stocks.values():
		var hcontainer = HBoxContainer.new()
		
		var good = Button.new()
		good.text = stock.good
		hcontainer.add_child(good)
		
		var quantity = Button.new()
		quantity.text = str(stock.quantity)
		hcontainer.add_child(quantity)
		
		var price = Button.new()
		price.text = str(stock.price)
		hcontainer.add_child(price)
		
		market_container.add_child(hcontainer)
		






func clear_province_panel():
	for child in tab_bar.get_children():
		for grandchild in child.get_children():
			grandchild.queue_free()


#handle enabling and diabling of the UI
func enable():
	visible = true
	mouse_filter = MOUSE_FILTER_STOP
	$TabContainer.mouse_filter = MOUSE_FILTER_STOP
	update_province_panel()
	
func disable():
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
	$TabContainer.mouse_filter = MOUSE_FILTER_IGNORE
