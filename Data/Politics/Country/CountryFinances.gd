extends Resource
class_name Finances

var country: Country
var balance: float
var reserves_debt = 0.0
var interest_rate = 0.05

enum income_types {
	PER_CAPITA_TAX,
	INCOME_TAX,
	PROFIT_TAX,
	TARIFF_INCOME,
	MINTING,
	STATE_OWNED_INDUSTRY_INCOME
}
var incomes = {
	income_types.PER_CAPITA_TAX: 0.0,
	income_types.INCOME_TAX: 0.0,
	income_types.PROFIT_TAX: 0.0,
	income_types.TARIFF_INCOME: 0.0,
	income_types.MINTING: 0.0,
	income_types.STATE_OWNED_INDUSTRY_INCOME: 0.0,
}

var total_income: float

enum expense_types {
	PUBLIC_CONSTRUCTION,
	ADMIN_WAGES,
	ADMIN_MATERIAL,
	ARMY_WAGES,
	ARMY_MATERIAL,
	INTEREST,
	STATE_OWNED_INDUSTRY_LOSSES,
}
var expenses = {
	expense_types.PUBLIC_CONSTRUCTION: 0.0,
	expense_types.ADMIN_WAGES: 0.0,
	expense_types.ADMIN_MATERIAL: 0.0,
	expense_types.ARMY_WAGES: 0.0,
	expense_types.ARMY_MATERIAL: 0.0,
	expense_types.INTEREST: 0.0,
	expense_types.STATE_OWNED_INDUSTRY_LOSSES: 0.0
}
var total_expenses: float

func reset_cycle():
	for key in incomes.keys():
		incomes[key] = 0.0
	for key in expenses.keys():
		expenses[key] = 0.0

func calculate_balance():
	incomes[income_types.MINTING] = calculate_minting()
	expenses[expense_types.INTEREST] = reserves_debt * interest_rate if reserves_debt < 0 else 0
	total_income = 0.0
	total_expenses = 0.0
	for key in incomes:
		total_income += incomes[key]
	for key in expenses:
		total_expenses += expenses[key]
	balance = total_income - total_expenses
	reserves_debt += balance


func calculate_minting():
	return 1000.0
