extends Panel

@onready var name_label = $TabContainer/Production/NameLabel
@onready var revenue = $TabContainer/Production/Balance/Revenue
@onready var input_goods = $TabContainer/Production/Throughput/Input
@onready var output_goods = $TabContainer/Production/Throughput/Output
@onready var cashreserve = $TabContainer/Production/Balance/Cashreserve
@onready var input_costs = $TabContainer/Production/Balance/InputCost
@onready var wage_cost = $TabContainer/Production/Balance/WageCost
@onready var total = $TabContainer/Production/Balance/Total
@onready var employment_bar = $TabContainer/Production/EmploymentBar
@onready var asset_grid = $TabContainer/Assets/AssetGrid
@onready var employment_table =$TabContainer/Employees/DynamicTable

var selected_workplace: Workplace
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UI.connect("sig_update_workplace_panel",Callable(self,"on_update_workplace_panel"))
	GameState.workplace_ui = self
	disable()
	var close_button = $CloseButton
	close_button.connect("pressed", Callable(self, "disable"))
	close_button.text = "X"
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	
	
func enable():
	visible = true
	mouse_filter = MOUSE_FILTER_STOP
	
func disable():
	#print("close")
	selected_workplace = null
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
	

func _on_building_selected(workplace:Workplace):
	enable()
	selected_workplace = workplace
	on_update_workplace_panel()

func on_update_workplace_panel():
	if selected_workplace == null:
		return

	name_label.text = selected_workplace.workplace_type.name
	
	#employment
	employment_bar.max_value = selected_workplace.get_maximum_total_employment()
	employment_bar.value = selected_workplace.get_current_total_employment() 
	
	#Balance Labels
	revenue.text = "Revenue: " + str(snapped(selected_workplace.turnover,0.01) )
	input_costs.text = "Input Costs: " + str(snapped(selected_workplace.input_cost,0.01))
	cashreserve.text = "Cashreserve: " + str(snapped(selected_workplace.cash_reserve,0.01))
	wage_cost.text = "Wage Cost: " + str(snapped(selected_workplace.total_wage_costs,0.01))
	total.text = "Profit: " + str(snapped(selected_workplace.profit,0.01))
	
	clear_building_ui()
	
	#input
	for good in selected_workplace.production.actual_input:
		var input_label = Label.new()
		input_label.text = good + ": " + str(selected_workplace.production.actual_input.get_or_add(good,0)) + "/" + str(selected_workplace.production.order_input.get_or_add(good,0))
		input_goods.add_child(input_label)
	#output
	for good in selected_workplace.production.output:
		var output_label = Label.new()
		output_label.text = good + ": " + str(selected_workplace.production.output.get_or_add(good,0)) + "/" + str(selected_workplace.production.actual_output.get_or_add(good,0))
		output_goods.add_child(output_label)


	#Assets
	for asset in selected_workplace.assets.values():
		var asset_panel = preload("res://Scenes/Asset_Panel/asset.tscn").instantiate()
		print(selected_workplace.assets)
		asset_grid.add_child(asset_panel)
		asset_panel.set_asset(asset)
	
	#Employment
	var headers = ["Poptype", "Current Employment", "Desired Employment"] # use |align for alignment columns (l, c, r or L, C, R)
	employment_table.set_headers(headers)
	
	var data = []
	for poptype in selected_workplace.desired_employment:
		var row = [poptype, selected_workplace.actual_employment.get_or_add(poptype,0),selected_workplace.desired_employment[poptype]]
		data.append(row)
	
	employment_table.set_data(data)
	
func clear_building_ui():
	for child in %workplace_ui/TabContainer/Production/Throughput.get_children():
		for grandchild in child.get_children():
			grandchild.queue_free()
	for child in asset_grid.get_children():
		child.queue_free()
