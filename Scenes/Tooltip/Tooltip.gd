extends Control

@export var lock_delay := 2.0  # Time in seconds before tooltip locks
var is_locked := false
var timer := 0.0
var nested_tooltip
@onready var core_tooltip = get_tree().root.get_node_or_null("Main/UI/Tooltip")
var hover_timer := Timer.new()
var meta
var text

var tooltip_scene = preload("res://Scenes/Tooltip/tooltip.tscn")


func _ready():
	hide()
	hover_timer.wait_time = 1.0
	hover_timer.one_shot = true
	hover_timer.ignore_time_scale = true
	hover_timer.connect("timeout", Callable(self, "_on_hover_timeout").bind(meta))
	add_child(hover_timer)


func show_tooltip(text: String, origin: Control):
	print("hovered")
	var origin_rect = origin.get_global_rect()
	print()
	$InititialTimer.connect("timeout",Callable(self,"_on_initial_timeout").bind(text,origin_rect))
	$InititialTimer.start()




func _on_label_meta_hover_started(meta: Variant) -> void:
	var content = str(meta)
	var mouse_pos = get_global_mouse_position()
	nested_tooltip = tooltip_scene.instantiate()
	self.add_child(nested_tooltip)
	nested_tooltip.show_tooltip("Another tooltip",self)

	


func _on_mouse_exited() -> void:
	print("exited")
	if not nested_tooltip == null:
		nested_tooltip.queue_free()
	hide()
func _on_mouse_entered():
	print("entered")


func _on_label_meta_hover_ended(meta: Variant) -> void:
	print("hover stopped")
	hover_timer.stop()

func _on_hover_timeout(meta: Variant):
	print("timeout")


func _on_initial_timeout(text,origin_rect):
	print("timeout")
	var position = get_global_mouse_position()
	if not origin_rect.has_point(position):
		return
	$Label.bbcode_enabled = true
	$Label.text = "This is a [url]Tooltip[/url]"
	$Label.connect("meta_hover_started", Callable(self, "_on_meta_hover_started"))
	$Label.connect("meta_hover_ended", Callable(self, "_on_meta_hover_ended"))
	self.connect("mouse_exited", Callable(self,"_on_mouse_exited"))
	self.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	global_position = position + Vector2(20,20)
	show()
