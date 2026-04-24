extends Resource
class_name Construction



var target_structure: Structure

var required_goods = {}
var delivered_goods = {}
var costs = 0.0
var construction_owner: Dictionary

func send_order():
	costs = 0.0
	var local_market = target_structure.region.market
	for good in required_goods:
		var amount = required_goods[good] - delivered_goods[good]
		amount = min(amount, required_goods[good] / 20.0)
		amount = ceil(amount)
		local_market.accept_construction_order(self,Goods.goods_list[good],amount)
	
func _init(structure: Structure, owner_type: Defines.OwnershipTypes, owner_object: Object) -> void:
	target_structure = structure
	required_goods = structure.construction_goods_level
	self.construction_owner = {
		Ownership.owner_dict.TYPE: owner_type,
		Ownership.owner_dict.OBJECT: owner_object,
	}
	if required_goods == null:
		required_goods = Goods.get_dummy()
	for good in required_goods:
		delivered_goods[good] = 0

func check_progress():
	if construction_owner[Ownership.owner_dict.TYPE] == Defines.OwnershipTypes.PUBLIC:
		pay_public_construction()
	var complete = true
	for good in required_goods:
		if required_goods[good] > delivered_goods[good]:
			complete = false
	if complete:
		print("construction done!")
		target_structure.construction_complete(construction_owner[Ownership.owner_dict.OBJECT])
		target_structure.region.remove_construction(self)
			

func pay_public_construction():
	var country = GameState.countries.get(target_structure.region.country)
	var finances = country.finances
	finances.expenses[finances.expense_types.PUBLIC_CONSTRUCTION] += costs
	
