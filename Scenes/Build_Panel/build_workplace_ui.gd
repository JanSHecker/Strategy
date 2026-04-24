extends NinePatchRect
@export var container:Control

const FONTSIZE = 12
@onready var sz_build_button = preload("res://Scenes/Build_Button/Build_Button.tscn")
var region

func _ready() -> void:
	visible = false
	UI.connect("sig_open_build_panel",Callable(on_add_building_button_pressed))
	UI.connect("sig_update_build_panel", Callable(on_update_build_panel))


func on_add_building_button_pressed(region: Region):
	self.region = region
	on_update_build_panel(region)
	visible = true
		
func _build_workplace(workplace):
	region.build_workplace(workplace)
	on_add_building_button_pressed(region)

func on_update_build_panel(region: Region):
	$LabelRect/Label.text = "Potential Buildings " + region.id
	for child in container.get_children():
		child.queue_free()
	var workplaces = region.workplaces
	var unbuild_workplaces = WP.LIST.keys().filter(func(a): return not workplaces.keys().has(a))
	
	for workplace in unbuild_workplaces:
		var button = sz_build_button.instantiate()
		button.fill(workplace,self)
		container.add_child(button)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		visible = false
