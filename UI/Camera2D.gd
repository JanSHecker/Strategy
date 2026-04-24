extends Camera2D


# Called when the node enters the scene tree for the first time.
var zoomSpeed: float = 0.01
var zoomMin: float = 0.001
var zoomMax:float = 2.5
var dragSensitivity: float = 5

func _ready():
	position = Vector2(Defines.MAP_WIDTH/2,Defines.MAP_HEIGHT/2)
	zoom = Vector2(0.15,0.15)
	
func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		if UI.is_under_active_ui(event.position):
			return
		position -= event.relative * dragSensitivity
	if event is InputEventMouseButton:
		if UI.is_under_active_ui(event.position):
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoomSpeed, zoomSpeed) * (zoom.x + zoom.y)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoomSpeed, zoomSpeed) * (zoom.x + zoom.y)
		zoom = clamp(zoom, Vector2(zoomMin, zoomMin), Vector2(zoomMax, zoomMax))
	#if zoom < Vector2(0.2,0.2):
		#GameState.grid.visible = false
	#if zoom > Vector2(0.2,0.2):
		#GameState.grid.visible = true
