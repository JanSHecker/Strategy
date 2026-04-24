extends Asset
class_name BessemerProcess

func _init(workplace: Workplace):
	self.workplace = workplace
	self.asset_type = AssetDefinition.BESSEMER_PROCESS
	self.asset_maximum_per_level = 1
	self.asset_cost = {
		Goods.MACHINES[Goods.name]: 250,
	}
	self.additional_employment_per_level = {
		Poptypes.TECHNICIAN: 30 ,
		Poptypes.ENGINEER: 10,
	}
	self.additional_input_per_level = {
		Goods.IRON.name: 100,
		Goods.COAL.name: 100,
	}
	self.additional_output_per_level = {
		Goods.STEEL[Goods.name]: 100,
	}
	self.asset_decay_per_year = 0
