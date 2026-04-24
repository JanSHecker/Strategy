extends NinePatchRect

@export var country_name: Control
@export var finance_button: Control


func _ready() -> void:
	UI.sig_update_country_overview.connect(Callable(self,"update"))
	finance_button.connect("pressed",Callable(UI,"open_country_panel"))
	update()
	
	
	
func update():
	var player_country_id = GameState.player_country_id
	var player_country = GameState.countries.get(player_country_id)
	if not player_country:
		return
	country_name.text = player_country.name
