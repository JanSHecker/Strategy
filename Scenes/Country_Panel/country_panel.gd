extends NinePatchRect


const FONTSIZE = 12

func _ready() -> void:
	visible = false
	UI.connect("sig_update_country_panel", Callable(self, "on_update_country_panel"))
	UI.connect("sig_open_country_panel",Callable(self, "on_open_country_panel"))
	GameState.country_panel = self
	
	
func on_update_country_panel():
	for child in $TabContainer/Budget/Income/VBoxContainer.get_children():
		child.queue_free()
	for child in $TabContainer/Budget/Expenses/VBoxContainer2.get_children():
		child.queue_free()
	var country_id = GameState.player_country_id
	var country = GameState.countries.get(country_id)
	var finances = country.finances
	
	for key in finances.incomes:
		var label = Label.new()
		label.text = Loc.INCOME_TYPES[key] + ": " + str(finances.incomes[key])
		label.add_theme_font_size_override("font_size",FONTSIZE)
		$TabContainer/Budget/Income/VBoxContainer.add_child(label)
	
	for key in finances.expenses:
		var label = Label.new()
		label.text = Loc.EXPENSE_TYPES[key] + ": " + str(finances.expenses[key])
		label.add_theme_font_size_override("font_size",FONTSIZE)
		$TabContainer/Budget/Expenses/VBoxContainer2.add_child(label)

	$TabContainer/Budget/Balance/Label.text = "Balance: " + Tools.display_high_numbers(finances.balance)
	var reserves = Tools.display_high_numbers(finances.reserves_debt)
	$TabContainer/Budget/Reserves/Label.text = "Reserves: " + reserves if finances.reserves_debt >= 0 else "Debt: " + reserves
	
	
	var private_investment = country.private_investment
	
	$TabContainer/Investment/VBoxContainer/DepositedInvestment.text = "Deposited Investment: " + Tools.display_high_numbers(private_investment.budget)




func on_open_country_panel():
	visible = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		close()
		
		
func close():
	visible = false
