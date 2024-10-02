extends TileMapLayer

@onready var ui_panel: Panel = %province_panel

var selected_province

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.map_cursor = self
	print_tree()
	print("tree")

	print(ui_panel)
	ui_panel.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func highlight_selected_province(location: Vector2i):
	clear()
	set_cell(location,1,Vector2i(0,0))
	selected_province = GameState.get_province(location)
	ui_panel.enable()
	

func deselect_province():
	clear()
	ui_panel.disable()
	selected_province = null
