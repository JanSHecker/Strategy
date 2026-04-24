extends Resource
class_name Consumption_Level


static  var consumption_levels = {}
# Define consumption levels per need type for your game
static var survival_consumption_levels = {}
static var MAX_SURVIVAL_NEEDS = 10

static var life_consumption_levels = {}
static var MAX_LIFE_NEEDS = 30

static var luxury_consumption_levels = {}
static var MAX_LUXURY_NEEDS = 100
# Function to generate the consumption levels from 1 to 100
static func generate_consumption_levels():
	# Generate consumption levels from 1 to 100
	for level in range(1, 100):
		consumption_levels[level] = {
			Needs.NEED_GROUPS.SURVIVAL_NEEDS: min(level,MAX_SURVIVAL_NEEDS),
			Needs.NEED_GROUPS.LIFE_NEEDS: min(max(level - 8,0),MAX_LIFE_NEEDS),
			Needs.NEED_GROUPS.LUXURY_NEEDS: min(max(level - 16,0),MAX_LUXURY_NEEDS),
		}
	print(consumption_levels)




static func generate_survival_consumption_level():
	for level in range(1,MAX_SURVIVAL_NEEDS +1):
		survival_consumption_levels[level] = {
			Needs.Needtype.FOOD: 0.2 + level * 0.8, 
			Needs.Needtype.HEATING: 0.05 * level * 0.3, 
			Needs.Needtype.MIN_CLOTHING: 0.1 * level * 0.6, 
		}

static func generate_life_consumption_level():
	for level in range(1,MAX_LIFE_NEEDS + 1):
		life_consumption_levels[level] = {
			Needs.Needtype.STANDARD_CLOTHING: 0.3 * pow(2,level),
			Needs.Needtype.HOUSEHOLD_ITEMS:  0.3 * pow(2,level),
			Needs.Needtype.VICES: 0.3 * pow(2,level),
		}

static func generate_luxury_consumption_level():
	for level in range(1,MAX_SURVIVAL_NEEDS + 1):
		luxury_consumption_levels[level] = {
			Needs.Needtype.LUXURY_DRINK: 0.4 * pow(2,level),
			Needs.Needtype.LUXURY_FOOD: 0.4 * pow(2,level),
			Needs.Needtype.MEDIA: 0.3 * pow(2,level)
		}
