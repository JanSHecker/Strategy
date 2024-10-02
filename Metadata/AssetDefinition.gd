extends Resource
class_name AssetDefinition

static var manual_tools_logging = Asset.new(
	"Manual Tools Logging",
	100,
	{Goods.TOOLS: 100},
	{Poptypes.MACHINIST:50},
	{},
	{Goods.WOOD: 50},
	1
)
