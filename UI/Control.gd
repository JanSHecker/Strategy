extends Control

# Signal für den Speed
signal speed_changed(new_speed)

# Variable, um die aktuelle Geschwindigkeit zu speichern
var current_speed = 1.0
# Spiel-Datum als einfache Werte (du kannst sie auch als echte Datumstypen verwalten)
var weekday_counter = 1
var display_day = 1
var game_month = 1
var game_year = 1000

var weekday = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]


var speed_buttons = []
# Zeigt an, wie schnell die Zeit tickt (Anzahl der Sekunden für 1 Ingame-Tag)
var time_per_day = 1.0  # 1 echter Sekunde = 1 Ingame-Tag (kann angepasst werden)

# Timer für die Zeitaktualisierung
var time_passed = 0.0

# Referenz zum Label, das das Datum anzeigt
@onready var weekday_label = $Time/Weekday/WeekdayLabel
@onready var date_label = $Time/Date/DateLabel  # Passe den Pfad entsprechend deiner Scene an

# Diese Funktion wird aufgerufen, wenn der Spieler auf eine Geschwindigkeitstaste klickt
func _on_speed_button_pressed(speed: float):
	# Unpress all buttons before pressing the selected one
	for button in speed_buttons:
		button.set_pressed(false)
	
	# Set the currently pressed button to true
	speed_buttons[speed].set_pressed(true)
	
	# Update the current speed and the engine time scale
	current_speed = speed
	Engine.time_scale = current_speed

func _ready():
	# Link buttons to speed change function
	  # Initially set the speed to 0
	weekday_label.text = weekday[0]
	date_label.text = "Date: %02d/%02d/%d" % [display_day, game_month, game_year]
	$Time/ButtonPause.connect("pressed", Callable(self, "_on_speed_button_pressed").bind(0))  # Pause
	speed_buttons.append($Time/ButtonPause)
	
	$Time/Button1x.connect("pressed", Callable(self, "_on_speed_button_pressed").bind(1))     # 1x speed
	speed_buttons.append($Time/Button1x)
	
	$Time/Button2x.connect("pressed", Callable(self, "_on_speed_button_pressed").bind(2))     # 2x speed
	speed_buttons.append($Time/Button2x)
	
	$Time/Button3x.connect("pressed", Callable(self, "_on_speed_button_pressed").bind(3))     # 3x speed
	speed_buttons.append($Time/Button3x)
	_on_speed_button_pressed(0)
	print(speed_buttons)
# Prozess, der jeden Frame läuft und das Datum aktualisiert
func _process(delta: float):
	# Aktualisiere die vergangene Zeit, multipliziert mit der Spielgeschwindigkeit
	time_passed += delta * current_speed

	# Überprüfen, ob ein Tag vergangen ist
	if time_passed >= time_per_day:
		time_passed = 0.0  # Zeit zurücksetzen
		advance_game_date()  # Datum um einen Tag weiterstellen
		
# Funktion, um das Ingame-Datum um einen Tag voranzuschreiten
func advance_game_date():
	weekday_counter += 1
	display_day += 1
	GameState.daily_tick()
	if weekday_counter == 7:
		GameState.weekly_tick()
		weekday_counter = 0
	if display_day > 30:  # Einfache Annahme: Jeder Monat hat 30 Tage
		display_day = 1
		game_month += 1
		GameState.monthly_tick()
		if game_month > 12:  # Wechsel des Jahres
			game_month = 1
			game_year += 1
			GameState.yearly_tick()

	# Aktualisiere das UI-Label, um das neue Datum anzuzeigen
	weekday_label.text = weekday[weekday_counter - 1]
	date_label.text = "Date: %02d/%02d/%d" % [display_day, game_month, game_year]
	
