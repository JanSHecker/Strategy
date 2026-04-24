extends Node

# Declare the signals
signal sig_update_region_panel
signal sig_update_workplace_panel
signal sig_update_country_overview
signal sig_update_country_panel
signal sig_update_pop_panel
signal sig_update_build_panel

signal sig_open_pop_panel(pop: Pop)
signal sig_open_country_panel
signal sig_open_build_panel(region: Region)

# Emit the region panel signal
func update_region_panel():
	emit_signal("sig_update_region_panel")

# Emit the workplace panel signal
func update_workplace_panel():
	emit_signal("sig_update_workplace_panel")
	
func update_country_overview():
	emit_signal("sig_update_country_overview")	

# Emit the country panel signal
func update_country_panel():
	emit_signal("sig_update_country_panel")

func update_pop_panel():
	emit_signal("sig_update_pop_panel")

func update_build_panel(region):
	emit_signal("sig_update_build_panel",region)


func open_build_panel(region: Region):
	emit_signal("sig_open_build_panel",region)

func open_pop_panel(pop: Pop):
	emit_signal("sig_open_pop_panel",pop)

func open_country_panel():
	emit_signal("sig_open_country_panel")



func is_under_active_ui(mouse_position):
	var ui = get_tree().root.get_node("Main/UI")
	for element in ui.get_children():
		if element.get_global_rect().has_point(mouse_position) && (element.visible):
			return true
