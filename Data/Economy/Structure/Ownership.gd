extends Node
class_name Ownership

var workplace: Workplace
var owners = []


enum owner_dict {
	TYPE,
	OBJECT,
	AMOUNT,
}


func _init(workplace: Workplace) -> void:
	self.workplace = workplace

func add_owner(type: Defines.OwnershipTypes , object: Object, amount: int):
	var owner = {
		owner_dict.TYPE: type,
		owner_dict.OBJECT: object,
		owner_dict.AMOUNT: amount,
	}
	if owners.has(owner):
		return
	owners.append(owner)

func transfer_ownership(source_obj: Object, target_obj: Object, amount: int):
	var source = get_workplace_owner(source_obj)
	var target = get_workplace_owner(target_obj)
	var has_owners = owners.has(source) and owners.has(target)
	const amount_key = owner_dict.AMOUNT
	if not has_owners :
		return
	amount = min(amount,source[amount_key]) #Transfer at max as much levels as the source has available
	source[amount_key] -= amount
	target[amount_key] += amount

func modify_ownership_amount(target_owner: Object, amount: int):
	var target_ownership = get_workplace_owner(target_owner)
	if target_ownership[owner_dict.TYPE]: 
		target_ownership[owner_dict.AMOUNT] += amount
	if target_ownership[owner_dict.AMOUNT] <= 0:
		owners.erase(target_ownership)

func get_workplace_owner(target_owner: Object):
	var key = owners.find_custom(
		func(a): return a[owner_dict.OBJECT] == target_owner
	)
	if key == -1:
		return {
		owner_dict.TYPE: null,
		owner_dict.OBJECT: target_owner,
		owner_dict.AMOUNT: 0,
		}
	return owners[key]

func receive_dividends(type:):
	return
