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

#enum Biome {
 	#SCORCHED, 
	#BARE, 
	#TUNDRA, 
	#SNOW, 
	#TEMPERATE_DESERT, 
	#SHRUBLAND, 
	#TAIGA, 
	#GRASSLAND,
	#TEMPERATE_DECIDUOUS_FOREST,
	#TEMPERATE_RAIN_FOREST,
	#SUBTROPICAL_DESERT,
	#TROPICAL_SEASONAL_FOREST,
	#TROPICAL_RAIN_FOREST
	#}

func _init(elevation_: float, humidity_: float, temperature_: float): 
	elevation = elevation_
	humidity = humidity_
	temperature = temperature_
	
	var mapping_x: int = int(humidity * 100)
	var mapping_y: int = int(100 - (elevation * 100) - 10)
	
	mapping_y = clamp(mapping_y, 0, 99)
	mapping_x = clamp(mapping_x, 0, 99)
	
	terrain_color = biomes_mapping.get_pixel(mapping_x, mapping_y)
