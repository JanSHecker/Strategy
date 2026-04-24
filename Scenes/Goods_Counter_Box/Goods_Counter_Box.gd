extends NinePatchRect

@export var name_label:Control
@export var requirements_bar_container: Control
@export var close_button:Control

const GOODS_FONTSIZE = 12
	

func fill_construction(construction: Construction) -> void:
	name_label.text = construction.target_structure.name
	
	for good in construction.required_goods:
		var good_label = Label.new()
		good_label.text = good + ": " + str(snapped(construction.delivered_goods[good],0.1)) + "/" + str(construction.required_goods[good])
		good_label.add_theme_font_size_override("font_size",GOODS_FONTSIZE)
		requirements_bar_container.add_child(good_label)
	close_button.connect("pressed",Callable(construction.target_structure,"downsize"))

func fill_need(name: String,need: Dictionary, received_good: Dictionary, substitution: Dictionary):
	close_button.queue_free()
	name_label.text = name
	for good in need:
		var good_label = Label.new()
		good_label.text = good.name + ": " + str(received_good[good]) + "/" + str(need[good]) + " " + str(substitution[good])
		good_label.add_theme_font_size_override("font_size",GOODS_FONTSIZE)
		requirements_bar_container.add_child(good_label)
