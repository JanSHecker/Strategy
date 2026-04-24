extends TileMapLayer

@onready var ui_panel: Panel = %province_panel

var selected_province: Province

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.map_cursor = self
	ui_panel.visible = false

func highlight_selected_province(location: Vector2i):
	clear()
	set_cell(location,1,Vector2i(0,0))
	var province_id = GameState.locations[location]
	selected_province = GameState.provinces[province_id]
	ui_panel.enable()
	

func deselect_province():
	clear()
	ui_panel.disable()
	selected_province = null
