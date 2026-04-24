extends Control

@export var name_label:Control
@export var open_workplace_button:Control
@export var size_label:Control
@export var invest_button:Control
@export var downsize_button:Control
@export var build_progress:Control
@export var productivity_label:Control


@onready var tooltip = get_tree().root.get_node("Main/UI/Tooltip")
func fill(workplace:Workplace, workplace_ui:Control) -> void:
	name_label.text = workplace.workplace_type["name"]
	size_label.text = str(workplace.size) + " + " + str(workplace.size_under_construction)
	var productivity_snapped = snapped(workplace.productivity,0.01)
	var scale_snapped = snapped(workplace.production.desired_production_scale,0.01)
	productivity_label.text = str(productivity_snapped) + " | " + str(scale_snapped)

	
	open_workplace_button.connect("pressed", Callable(workplace_ui, "_on_building_selected").bind(workplace))
	
	
	var state_owner = {
		Ownership.owner_dict.TYPE: Defines.OwnershipTypes.PUBLIC,
		Ownership.owner_dict.OBJECT: GameState.countries.get(GameState.player_country_id),
		Ownership.owner_dict.AMOUNT: 0,
	}
	
	
	invest_button.connect("pressed", Callable(workplace,"expand").bind(state_owner))
	downsize_button.connect("pressed", Callable(workplace,"downsize"))
	invest_button.connect("mouse_entered",Callable(_on_mouse_entered))



func _on_mouse_entered():
	tooltip.show_tooltip("This is a tooltip",invest_button)
