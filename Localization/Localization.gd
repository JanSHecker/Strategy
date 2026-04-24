extends Node
class_name Loc

static var income_types = Finances.income_types

static var INCOME_TYPES = {
	income_types.PER_CAPITA_TAX: "Per-capita tax",
	income_types.INCOME_TAX: "Income tax",
	income_types.PROFIT_TAX: "Profit tax",
	income_types.TARIFF_INCOME: "Tariff income",
	income_types.MINTING: "Minting",
	income_types.STATE_OWNED_INDUSTRY_INCOME: "State-owned industries income",
}

static var expense_types = Finances.expense_types

static var EXPENSE_TYPES = {
	expense_types.PUBLIC_CONSTRUCTION: "Public construction cost",
	expense_types.ADMIN_WAGES: "Administrative wages cost",
	expense_types.ADMIN_MATERIAL: "Administrative material cost",
	expense_types.ARMY_WAGES: "Military wages cost",
	expense_types.ARMY_MATERIAL: "Army material cost",
	expense_types.INTEREST: "Interest on debt",
	expense_types.STATE_OWNED_INDUSTRY_LOSSES: "State-owned industry losses"
}

static var need_types = Needs.Needtype

static var NEED_TYPES = {
	need_types.FOOD: "Food",
	need_types.MIN_CLOTHING: "Minimal clothing",
	need_types.HEATING: "Heating",
	need_types.VICES: "Vices",
	need_types.STANDARD_CLOTHING: "Standard clothing",
	need_types.HOUSEHOLD_ITEMS: "Household items",
	need_types.LUXURY_FOOD: "Luxury food",
	need_types.LUXURY_DRINK: "Luxury drink",
	need_types.MEDIA: "Media"
}
