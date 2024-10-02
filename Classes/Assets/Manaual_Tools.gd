extends Asset
class_name ManualToolsLogging

func _init():
	self.asset_maximum_per_level = 10
	self.asset_cost = {
		Goods.TOOLS: 100,
	}
	self.additional_employment_per_level = {
		Poptypes.MACHINIST: 50,
		Poptypes.WORKER: 50,
	}
	self.additional_input_per_level = {
		Goods.STONE: 5,
	}
	self.additional_output_per_level = {
		Goods.WOOD: 50,
	}
	self.asset_decay_per_year = 1
