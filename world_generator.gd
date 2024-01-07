extends Object
class_name HexWorldGenerator

var world_radius: int = 128
var world_center: Hex = Hex.new(0,0,0)

var world_seed: int = RandomNumberGenerator.new().randi()
var elevation_noise: FastNoiseLite = FastNoiseLite.new()
var elevation_snap_step = 0.05

var humidity_noise: FastNoiseLite = FastNoiseLite.new()
var humidity_snap_step = 0.05

var elevation_k: float = 0.45

func correct_elevation(hex: Hex, elevation: float) -> float:
	var distance = float(hex.distance_to(Hex.new(0,0,0)))
	var max_distance = float(world_radius)
	var distance_k = 1.0 / max_distance
	var d = distance_k * distance
	elevation = lerp(elevation, 1-(d*2), elevation_k)
	elevation = lerp(elevation, sign(elevation), abs(elevation)*0.4)
	return elevation

	
func apply_default_noise_settings():
	elevation_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	humidity_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	elevation_noise.seed = world_seed
	humidity_noise.seed = world_seed + 1

func generate_map() -> HexRegion:
	apply_default_noise_settings()
	var hex_region = HexRegion.new_hexagon(world_radius, world_center)
	
	for hex in hex_region.get_hexes():
		var elevation: float
		var humidity: float
		var tile_info: TileInfo
		
		var elevation_noise_value = elevation_noise.get_noise_3d(hex.q, hex.r, hex.s)
		elevation = correct_elevation(hex, elevation_noise_value)
		elevation = snapped(elevation, elevation_snap_step)
		
		var humidity_noise_value = humidity_noise.get_noise_3d(hex.q, hex.r, hex.s)
		humidity = (humidity_noise_value / 2.0) + 0.5
		humidity = snapped(humidity, humidity_snap_step)
		
		tile_info = TileInfo.new(
			elevation,
			humidity,
			0.0 # TODO: generate temperature
		)
		
		hex_region.set_value(hex, tile_info)
	
	return hex_region
