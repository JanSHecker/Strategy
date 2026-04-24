extends Workplace
class_name Steel_Mill

var base_output = {
	Goods.STEEL.name: 40,
}

func _init(region: Region) -> void:
	self.base_employment_per_level = {
		Poptypes.WORKER: 90,
		Poptypes.MACHINIST: 10,
	}
	self.region = region
	self.size = 1
	GameState.workplace_register.append(self)
	self.assets = {
		AssetDefinition.BessemerProcess: BessemerProcess.new(self),
	}
