extends NinePatchRect

var need_box_scene = preload("res://Scenes/Goods_Counter_Box/Goods_Counter_Box.tscn")
var active_pop: Pop

@export var needs_container: Control
@export var close_button: Control
@export var balance_label: Control
@export var consumption_label: Control

func _ready() -> void:
	visible = false
	UI.connect("sig_open_pop_panel",Callable(on_pop_button_pressed))
	UI.connect("sig_update_pop_panel", Callable(on_update_pop_panel))
	close_button.connect("pressed",on_close_button_pressed)

func on_update_pop_panel():
	clear()
	if active_pop == null:
		return
	var needs = active_pop.goods_per_need
	var fulfills = active_pop.fulfilled_per_need
	var substitutions = active_pop.need_substitutions
	#print(needs)
	for key in needs:
		var need = needs[key]
		var fulfill = fulfills[key] 
		var substitution = substitutions[key]
		var need_box = need_box_scene.instantiate()
		need_box.fill_need(Loc.NEED_TYPES[key],need,fulfill,substitution)
		needs_container.add_child(need_box)
	balance_label.text = "Budget: " + str(snapped(active_pop.budget,0.01)) + " | Total Expenses: " + str(snapped(active_pop.expenses,0.01)) + " | Balance: " + str(snapped(active_pop.balance,0.01))
	consumption_label.text = "Consumption Level: " + str(active_pop.consumption_level) + " " + str(active_pop.needs.get_or_add(0,{})) + JSON.stringify(active_pop.avg_per_group) 

func activate():
	visible = true
	
func disable():
	visible = false
	
func on_pop_button_pressed(pop: Pop):
	active_pop = pop 
	on_update_pop_panel()
	activate()

func clear():
	for child in needs_container.get_children():
		child.queue_free()

func on_close_button_pressed():
	disable()
