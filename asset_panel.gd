extends Control

@onready var name_label = $VBoxContainer/AssetNameLabel
@onready var logo = $VBoxContainer/HBoxContainer/AssetLogo
@onready var asset_effects = $VBoxContainer/HBoxContainer/AssetEffects
@onready var progress_nr = $VBoxContainer/ProgressNR
@onready var progress_bar = $VBoxContainer/ProgressBar





func set_asset(asset):
	name_label.text = asset.asset_type
	asset_effects.queue_free()
	
	for employ in asset.additional_employment_per_level:
		var label = Label.new()
		label.text = employ + ": " + str(int(asset.additional_employment_per_level[employ] * asset.get_asset_coverage_percentage()))
		asset_effects.add_child(label)
	
	for input in asset.additional_input_per_level:
		var label = Label.new()
		label.text = input + ": " + str(int(asset.additional_input_per_level[input] * asset.get_asset_coverage_percentage()))
		asset_effects.add_child(label)
		
	for output in asset.additional_output_per_level:
		var label = Label.new()
		label.text = output + ": " + str(int(asset.additional_output_per_level[output] * asset.get_asset_coverage_percentage()))
		asset_effects.add_child(label)
		
	progress_nr.text = str(asset.asset_amount) + "/" + str(asset.workplace.size * asset.asset_maximum_per_level)
	progress_bar.max_value = asset.workplace.size * asset.asset_maximum_per_level
	progress_bar.value = asset.asset_amount
