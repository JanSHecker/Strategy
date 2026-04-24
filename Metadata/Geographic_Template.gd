extends Node
class_name GeoTemplate

enum all {
	WOOD_PLAINS,
	BARE_PLAINS,
	WOOD_HILLS,
	BARE_HILLS,
	WOOD_MOUNTAINS,
	BARE_MOUNTAINS,
}

enum Deposit {
	ARABLE,
	GRAZING,
	WOOD,
	STONE,
	COAL,
	IRON,
}

var templates = {
	all.WOOD_PLAINS: {
		"region": "Temperate Forest",
		"deposits": {
			Deposit.ARABLE:  {"min": 60, "max": 100},
			Deposit.GRAZING: {"min": 50, "max": 90},
			Deposit.WOOD:    {"min": 70, "max": 110},
			Deposit.STONE:   {"min": 30, "max": 60},
			Deposit.COAL:    {"min": 20, "max": 50},
			Deposit.IRON:    {"min": 10, "max": 30},
		},
	},

	all.BARE_PLAINS: {
		"region": "Grasslands",
		"deposits": {
			Deposit.ARABLE:  {"min": 70, "max": 110},
			Deposit.GRAZING: {"min": 60, "max": 100},
			Deposit.WOOD:    {"min": 10, "max": 30},
			Deposit.STONE:   {"min": 20, "max": 50},
			Deposit.COAL:    {"min": 10, "max": 30},
			Deposit.IRON:    {"min": 10, "max": 25},
		},
	},

	all.WOOD_HILLS: {
		"region": "Woodland Hills",
		"deposits": {
			Deposit.ARABLE:  {"min": 30, "max": 90},
			Deposit.GRAZING: {"min": 30, "max": 90},
			Deposit.WOOD:    {"min": 60, "max": 100},
			Deposit.STONE:   {"min": 50, "max": 90},
			Deposit.COAL:    {"min": 40, "max": 70},
			Deposit.IRON:    {"min": 10, "max": 30},
		},
	},

	all.BARE_HILLS: {
		"region": "Scrubland Hills",
		"deposits": {
			Deposit.ARABLE:  {"min": 20, "max": 60},
			Deposit.GRAZING: {"min": 40, "max": 80},
			Deposit.WOOD:    {"min": 10, "max": 30},
			Deposit.STONE:   {"min": 60, "max": 100},
			Deposit.COAL:    {"min": 50, "max": 80},
			Deposit.IRON:    {"min": 20, "max": 50},
		},
	},

	all.WOOD_MOUNTAINS: {
		"region": "Alpine Forest",
		"deposits": {
			Deposit.ARABLE:  {"min": 10, "max": 40},
			Deposit.GRAZING: {"min": 20, "max": 60},
			Deposit.WOOD:    {"min": 60, "max": 90},
			Deposit.STONE:   {"min": 70, "max": 110},
			Deposit.COAL:    {"min": 50, "max": 80},
			Deposit.IRON:    {"min": 30, "max": 60},
		},
	},

	all.BARE_MOUNTAINS: {
		"region": "Rocky Mountains",
		"deposits": {
			Deposit.ARABLE:  {"min": 0, "max": 20},
			Deposit.GRAZING: {"min": 10, "max": 40},
			Deposit.WOOD:    {"min": 0, "max": 20},
			Deposit.STONE:   {"min": 80, "max": 120},
			Deposit.COAL:    {"min": 60, "max": 90},
			Deposit.IRON:    {"min": 40, "max": 80},
		},
	},
}
