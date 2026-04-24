extends Resource
class_name Structure

#Modules
var production = Production.new(self)
var ownership = Ownership.new(self)


var name: String
var size: int
var size_under_construction: int
var region: Region

enum structure_types {
	WORKPLACE,
}



var construction_goods_level = {}

func expand(owner: Dictionary):
	size_under_construction +=1
	region.add_construction(self,owner)
	UI.update_region_panel()

func downsize():
	if size_under_construction > 0:
		var key = region.constructions.rfind_custom(func(a): return a.target_structure == self)
		var ongoing_construction = region.constructions[key]
		region.remove_construction(ongoing_construction) 
		size_under_construction -= 1
		UI.update_region_panel()
	elif size > 0:
		var state_owner = ownership.get_workplace_owner(region.owning_country)
		if state_owner[Ownership.owner_dict.AMOUNT] == 0:
			increase_size(-1, state_owner)

func construction_complete(construction_owner: Object):
	increase_size(1,construction_owner)
	size_under_construction -= 1
	
func increase_size(amount: int, owner: Object):
	size += amount
	ownership.modify_ownership_amount(owner,amount)
	UI.update_region_panel()
