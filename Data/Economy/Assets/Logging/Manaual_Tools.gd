extends Asset
class_name ManualToolsLogging

func _init(workplace: Workplace):
	self.workplace = workplace
	self.asset_type = AssetDefinition.MANUAL_TOOLS_LOGGING
	self.asset_maximum_per_level = 100
	self.asset_cost = {
		Goods.TOOLS[Goods.name]: 100,
	}
	self.additional_employment_per_level = {
		Poptypes.TECHNICIAN: 30 ,
	}
	self.additional_input_per_level = {
		
	}
	self.additional_output_per_level = {
		Goods.WOOD[Goods.name]: 50,
	}
	self.asset_decay_per_year = 1
