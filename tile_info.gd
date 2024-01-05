extends Object
class_name TileInfo

static var biomes_mapping: Image

static func _static_init():
	biomes_mapping = Image.new()
	biomes_mapping.load("res://biome-lookup-discrete.png")

var elevation: float
var humidity: float
var temperature: float
var terrain_color: Color

func _init(elevation_: float, humidity_: float, temperature_: float): 
	elevation = elevation_
	humidity = humidity_
	temperature = temperature_
	
	var mapping_x: int = humidity * 100
	var mapping_y: int = 100 - (elevation * 100) - 10
	
	mapping_y = min(99, mapping_y)
	
	terrain_color = biomes_mapping.get_pixel(mapping_x, mapping_y)
