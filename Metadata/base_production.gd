extends Resource
class_name BP

static var input = "input"
static var output = "output"
static var workers = "workers"

static var SUBSISTANCE = {
	input: {},
	output: {
		Goods.GRAIN.name: 40,
		Goods.WOOD.name: 1,
		Goods.STONE.name: 1,
		Goods.FABRIC.name: 1
	},
	workers: {
		Poptypes.PEASANT.name: 10_000,
	}
}

static var FARM = {
	input: {},
	output: {
		Goods.GRAIN.name: 40,
	},
	workers: {
		Poptypes.FARMHAND.name: 1000,
	}
}

static var LOGGING = {
	input: {},
	output: {
		Goods.WOOD.name: 40,
	},
	workers: {
		Poptypes.FARMHAND.name: 1000,
	}
}

static var FURNITURE = {
	input: {
		Goods.WOOD.name: 40,
	},
	output: {
		Goods.FURNITURE.name: 100,
	},
	workers: {
		Poptypes.ARTISAN.name: 300,
		Poptypes.LABORER.name: 700,
	}
}

static var IRON = {
	input: {},
	output: {
		Goods.IRON.name: 40,
	},
	workers: {
		Poptypes.LABORER.name: 1000,
	}
}

static var STONE = {
	input: {},
	output: {
		Goods.STONE.name: 40,
	},
	workers: {
		Poptypes.LABORER.name: 1000,
	}
}

static var COAL = {
	input: {},
	output: {
		Goods.COAL.name: 100,
	},
	workers: {
		Poptypes.LABORER.name: 1000,
	}
}

static var STEEL = {
	input: {
		Goods.IRON.name: 40,
		Goods.COAL.name: 40,
	},
	output: {
		Goods.STEEL.name: 100,
	},
	workers: {
		Poptypes.LABORER.name: 400,
		Poptypes.TECHNICIAN.name: 90,
		Poptypes.ENGINEER.name: 10,
	}
}

static var TOOLS = {
	input: {
		Goods.WOOD.name: 40,
	},
	output: {
		Goods.TOOLS.name: 40,
	},
	workers: {
		Poptypes.ARTISAN.name: 300,
		Poptypes.LABORER.name: 700,
	}
}

static var MACHINES = {
	input: {
		Goods.STEEL.name: 100,
		Goods.TOOLS.name: 30,
	},
	output: {
		Goods.MACHINERY.name: 100,
	},
	workers: {
		Poptypes.LABORER.name: 300,
		Poptypes.ARTISAN.name: 200,
	}
}

static var TEXTILE = {
	input: {},
	output: {
		Goods.FABRIC.name: 40
	},
	workers: {
		Poptypes.LABORER.name: 400,
		Poptypes.ARTISAN.name: 100,
	}
}

static var CLOTHING = {
	input: {
		Goods.FABRIC.name: 100
	},
	output: {
		Goods.CLOTHING.name: 100,
	},
	workers: {
		Poptypes.ARTISAN.name: 400,
		Poptypes.LABORER.name: 600,
	}
}

static var CONCRETE = {
	input: {
		Goods.STONE.name: 100,
	},
	output: {
		Goods.CONCRETE.name: 100,
	},
	workers: {
		Poptypes.LABORER.name: 800,
		Poptypes.TECHNICIAN.name: 200,
	}
}

static var FOOD = {
	input: {
		Goods.GRAIN.name: 100,
	},
	output: {
		Goods.GROCERIES.name: 100,
	},
	workers: {
		Poptypes.LABORER.name: 500,
		Poptypes.ARTISAN.name: 200,
	}
}

static var DISTILLERY = {
	input: {
		Goods.GRAIN.name: 100,
	},
	output: {
		Goods.ALCOHOL.name: 100,
	},
	workers: {
		Poptypes.LABORER.name: 400,
		Poptypes.ARTISAN.name: 100,
	}
}

static var TOBACCO = {
	input: {},
	output: {
		Goods.TOBACCO.name: 100,
	},
	workers: {
		Poptypes.FARMHAND.name: 1000,
	}
}

static var TEA = {
	input: {},
	output: {
		Goods.TEA.name: 100,
	},
	workers: {
		Poptypes.FARMHAND.name: 1000,
	}
}

static var COFFEE = {
	input: {},
	output: {
		Goods.COFFEE.name: 100,
	},
	workers: {
		Poptypes.FARMHAND.name: 1000,
	}
}

static var GLASS = {
	input: {
		Goods.STONE.name: 100,
		Goods.COAL.name: 50,
	},
	output: {
		Goods.GLASS.name: 100,
	},
	workers: {
		Poptypes.LABORER.name: 700,
		Poptypes.TECHNICIAN.name: 100,
		Poptypes.ARTISAN.name: 100,
	}
}

static var PAPER = {
	input: {
		Goods.WOOD.name: 100,
	},
	output: {
		Goods.PAPER.name: 100,
	},
	workers: {
		Poptypes.LABORER.name: 600,
		Poptypes.ARTISAN.name: 200,
	}
}

static var PRINT = {
	input: {
		Goods.PAPER.name: 100,
	},
	output: {
		Goods.PRINT_MEDIA.name: 100,
	},
	workers: {
		Poptypes.ARTISAN.name: 400,
		Poptypes.LABORER.name: 300,
	}
}

static var MACHINERY = {
	input: {
		Goods.STEEL.name: 100,
		Goods.TOOLS.name: 50,
	},
	output: {
		Goods.MACHINERY.name: 100,
	},
	workers: {
		Poptypes.TECHNICIAN.name: 150,
		Poptypes.ENGINEER.name: 50,
		Poptypes.LABORER.name: 300,
	}
}
