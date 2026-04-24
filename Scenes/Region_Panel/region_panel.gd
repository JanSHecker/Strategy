extends NinePatchRect

@export var tab_bar: Control
@export var info_container: Control
@export var population_container: Control
@export var workplaces_container:Control
@export var market_container:Control
@export var market_table:Control
@export var workplace_ui:Control
@export var new_workplaces_ui:Control
@export var region_name_label:Control
@export var constructions_panel:Control
@export var export_panel: Control
@export var import_panel:Control

var construction_panel = preload("res://Scenes/Goods_Counter_Box/Goods_Counter_Box.tscn")
var trade_panel = preload("res://Scenes/trade_box/trade.tscn")

var is_active:bool
func _ready() -> void:
	visible = false
	UI.connect("sig_update_region_panel",Callable(self,"on_update_region_panel"))

func on_update_region_panel():
	if GameState.selected_region == null:
		return
	clear_region_panel()
	var region_id = GameState.selected_region
	var region = GameState.regions.get(region_id)
	
	region_name_label.text = "Region " + str(region.id)
	
	#Info-panel
	var b_region = Button.new()
	var country = Button.new()

	if region != null:
		b_region.text = "Region ID: " + str(region.id)
		if region.country != null:
			country.text = "Country ID: " + region.country
	info_container.add_child(country)
	info_container.add_child(b_region)


	#Workplace-panel
	var workplace_button = preload("res://Scenes/Workplace_Button/workplace_button.tscn")
	for key in region.workplaces:
		var button = workplace_button.instantiate()
		button.fill(region.workplaces[key], workplace_ui)
		workplaces_container.add_child(button)
	var button = Button.new()
	button.text = "+ add new building"
	button.focus_mode = Control.FOCUS_NONE
	button.connect("pressed", Callable(UI,"open_build_panel").bind(region))
	workplaces_container.add_child(button)
	#Population-panel
	var label = Button.new()
	var population = region.get_population()
	var population_str: String

	if population >= 1_000_000:
		# Display in millions with at most 3 decimal places
		population = population / 1_000_000
		population = snapped(population,0.001)
		population_str = str(population)
		population_str = population_str + "M"
	elif population >= 1_000:
		# Display in thousands with at most 3 decimal places
		population = population / 1_000
		population = snapped(population,0.001)
		population_str = str(population)
		population_str = population_str + "K"
	else:
		# Display as is
		population_str = str(population)

	label.text = "Total Population: " + population_str
	population_container.add_child(label)
	
	for pop in region.pops.values():
		var hcontainer = HBoxContainer.new()
		
		var size = Button.new()
		size.text = str(pop.size)
		hcontainer.add_child(size)
		
		var type = Button.new()
		type.text = pop.type.name
		type.connect("pressed",Callable(UI,"open_pop_panel").bind(pop))
		hcontainer.add_child(type)
		
		population_container.add_child(hcontainer)
	
	#Market-panel
	var headers = ["Good","Price","Base","Demand","Supply","Production","Import","Consumption","Export"]
	var data = []
	var prices = region.market.prices
	var target_prices = region.market.target_prices
	var equilibrium_prices = region.market.equilibrium_prices
	var local_demand = region.market.latent_demand
	var export = region.market.export
	var sold_supply = region.market.sold_supply 
	var supplied_demand = region.market.supplied_demand
	var local_supply = region.market.offered_supply
	var import = region.market.import
	
	for good in region.market.prices:
		var row = [
			Goods.goods_list[good].name, #good
			str(snapped(prices[good],0.01)), #price
			#str(snapped(target_prices[good],0.01)), #target
			str(snapped(equilibrium_prices[good],0.01)), #equilib
			str(local_demand[good] + export[good]), # demand
			str(local_supply[good] + import[good]), #supply
			str(local_supply[good]), #produced
			str(import[good]), #import
			str(supplied_demand[good]), #consumption
			str(export[good]), #Export
			]
		data.append(row)
	
	market_table.set_data(data)
	market_table.set_headers(headers)

	#Constructions Panel
	for construction in region.constructions:
		var construction_box = construction_panel.instantiate()
		construction_box.fill_construction(construction)
		constructions_panel.add_child(construction_box)

# Trade Panel
	for good in region.market.external_trade_registry:
		for trade in region.market.external_trade_registry[good]:
			var trade_box = trade_panel.instantiate()
			trade_box.fill(trade)
			var is_export:bool = trade["isExport"]
			if is_export: 
				print("hi im here")
				export_panel.add_child(trade_box)
			else:
				import_panel.add_child(trade_box)
				
				


func clear_region_panel():
	for child in info_container.get_children():
		child.queue_free()
	for child in population_container.get_children():
		child.queue_free()
	for child in workplaces_container.get_children():
		child.queue_free()
	for child in constructions_panel.get_children():
		child.queue_free()
	for child in export_panel.get_children():
		child.queue_free()
	for child in import_panel.get_children():
		child.queue_free()

#handle enabling and diabling of the UI
func enable():
	is_active = true
	visible = true
	mouse_filter = MOUSE_FILTER_STOP
	tab_bar.mouse_filter = MOUSE_FILTER_STOP
	UI.update_region_panel()
	
func disable():
	is_active = false
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
	tab_bar.mouse_filter = MOUSE_FILTER_IGNORE
