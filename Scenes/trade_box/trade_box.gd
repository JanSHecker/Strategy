extends NinePatchRect

@export var home_market_button: Control
@export var other_market_button: Control
@export var trade_amount_label: Control
@export var direction_texture: Control

var TEXTURE_EXPORT = preload("res://Graphics/kenney_cursor-pack/PNG/Outline/Default/arrow_e.png")
var TEXTURE_IMPORT = preload("res://Graphics/kenney_cursor-pack/PNG/Outline/Default/arrow_w.png")

func fill(trade):
	var home_market
	var other_market
	if trade["isExport"] == true:
		home_market = trade["source"] 
		other_market = trade["target"]
		direction_texture.texture = TEXTURE_EXPORT
	else:
		home_market = trade["target"] 
		other_market = trade["source"]
		direction_texture.texture = TEXTURE_IMPORT
	
	trade_amount_label.text = trade["good"] + " " + str(trade["amount"])
	home_market_button.text = "Region: " + home_market.region.id
	other_market_button.text = "Region: " + other_market.region.id
