extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Toggle_political_map.connect("pressed", Callable(self, "_on_political_pressed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_political_pressed():
	GameState.politicalmap.visible = !GameState.politicalmap.visible  # Toggle visibility
