extends NinePatchRect

func fill(workplace: String, build_ui: Control):
	$LabelPanel/Label.text = workplace
	var button = $Button
	button.connect("pressed",Callable(build_ui,"_build_workplace").bind(workplace))
	button.focus_mode = Control.FOCUS_NONE
