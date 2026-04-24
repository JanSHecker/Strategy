extends Resource
class_name Needs

enum Needtype {
	FOOD,
	MIN_CLOTHING,
	HEATING,
	VICES,
	STANDARD_CLOTHING,
	HOUSEHOLD_ITEMS,
	LUXURY_FOOD,
	LUXURY_DRINK,
	MEDIA,
}

static var NEEDS = {
	Needtype.FOOD: {
		Goods.GRAIN:    {"min": 0.2, "default": 0.8, "max": 0.99},
		Goods.GROCERIES: {"min": 0.01, "default": 0.1, "max": 0.5},
		Goods.MEAT:     {"min": 0.2, "default": 0.1, "max": 0.5},
	},
	Needtype.MIN_CLOTHING: {
		Goods.FABRIC:   {"min": 0.3, "default": 0.5, "max": 0.7},
		Goods.CLOTHING: {"min": 0.3, "default": 0.5, "max": 0.7},
	},
	Needtype.HEATING: {
		Goods.WOOD:     {"min": 0.3, "default": 0.5, "max": 0.7},
		Goods.COAL:     {"min": 0.3, "default": 0.5, "max": 0.7},
	},
	Needtype.VICES: {
		Goods.TOBACCO:  {"min": 0.4, "default": 0.5, "max": 0.6},
		Goods.ALCOHOL:  {"min": 0.4, "default": 0.5, "max": 0.6},
	},
	Needtype.STANDARD_CLOTHING: {
		Goods.CLOTHING: {"min": 1.0, "default": 1.0, "max": 1.0},
	},
	Needtype.HOUSEHOLD_ITEMS: {
		Goods.TOOLS:     {"min": 0.4, "default": 0.5, "max": 0.6},
		Goods.FURNITURE: {"min": 0.4, "default": 0.5, "max": 0.6},
	},
	Needtype.LUXURY_FOOD: {
		Goods.DELICACIES: {"min": 0.3, "default": 0.5, "max": 0.7},
		Goods.GROCERIES:  {"min": 0.3, "default": 0.5, "max": 0.7},
	},
	Needtype.LUXURY_DRINK: {
		Goods.TEA:    {"min": 0.4, "default": 0.5, "max": 0.6},
		Goods.COFFEE: {"min": 0.4, "default": 0.5, "max": 0.6},
	},
	Needtype.MEDIA: {
		Goods.PRINT_MEDIA: {"min": 1.0, "default": 1.0, "max": 1.0},
	},
}

enum NEED_GROUPS {
	SURVIVAL_NEEDS, 
	LIFE_NEEDS,
	LUXURY_NEEDS,
}

static var NEEDS_GROUPS = {
	NEED_GROUPS.SURVIVAL_NEEDS: SURVIVAL_NEEDS,
	NEED_GROUPS.LIFE_NEEDS: LIFE_NEEDS,
	NEED_GROUPS.LUXURY_NEEDS: LUXURY_NEEDS,
}

static var SURVIVAL_NEEDS = [Needtype.FOOD,Needtype.MIN_CLOTHING,Needtype.HEATING]
static var LIFE_NEEDS = [Needtype.VICES,Needtype.STANDARD_CLOTHING,Needtype.HOUSEHOLD_ITEMS]
static var LUXURY_NEEDS = [Needtype.LUXURY_FOOD,Needtype.LUXURY_DRINK,Needtype.MEDIA]
