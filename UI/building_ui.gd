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

var selected_workplace: Workplace
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	update_workplace_ui()

func update_workplace_ui():
	if selected_workplace == null:
		return

	name_label.text = selected_workplace.workplace_type
	
	#employment
	employment_bar.max_value = selected_workplace.get_maximum_total_employment()
	employment_bar.value = selected_workplace.get_current_total_employment()
	
	#Balance Labels
	revenue.text = "Revenue: " + str(selected_workplace.turnover)
	input_costs.text = "Input Costs: " + str(selected_workplace.input_price)
	cashreserve.text = "Cashreserve: " + str(selected_workplace.cash_reserve)
	wage_cost.text = "Wage Cost: " + str(selected_workplace.total_wage_costs)
	total.text = "Total: " + str(selected_workplace.profit)
	
	clear_building_ui()
	
	#input
	for good in selected_workplace.order_input:
		var input_label = Label.new()
		input_label.text = good + ": " + str(selected_workplace.actual_input[good]) + "/" + str(selected_workplace.order_input[good])
		input_goods.add_child(input_label)
	#output
	for good in selected_workplace.output:
		var output_label = Label.new()
		output_label.text = good + ": " + str(selected_workplace.output[good])
		output_goods.add_child(output_label)


func clear_building_ui():
	for child in %workplace_ui/TabContainer/Production/Throughput.get_children():
		for grandchild in child.get_children():
			grandchild.queue_free()
