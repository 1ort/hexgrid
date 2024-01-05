extends Node2D

@onready
var layout = $HexLayout

var selected_hex: Hex
var cursor_hex: Hex
var path_line: Array[Hex]

var hex_radius = 64
var elevation_k = 0.45
var hex_region = HexRegion.new_hexagon(hex_radius, Hex.new(0, 0, 0))
var hexes = hex_region.get_hexes()

@export
var water_gradient: Gradient
@export
var ground_gradient: Gradient	

func correct_elevation(hex: Hex, elevation: float):
	var distance = float(hex.distance_to(Hex.new(0,0,0)))
	var max_distance = float(hex_radius)
	var distance_k = 1.0 / max_distance
	var d = distance_k * distance
	elevation = lerp(elevation, 1-(d*2), elevation_k)
	elevation = lerp(elevation, sign(elevation), abs(elevation)*0.4)
	return elevation

func generate_map():
	var noise = FastNoiseLite.new()
	var rng = RandomNumberGenerator.new()
	var noise_seed = rng.randi_range(0, 50000)
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX

	
	for hex in hex_region.get_hexes():
		#var tile_info = generate_hex_tile_info(hex, noise)
		var elevation: float
		var humidity: float
		var temperature: float
		var tile_info: TileInfo
		
		#elevation
		noise.fractal_octaves = 3
		noise.frequency = 0.05
		noise.seed = noise_seed
		var elevation_noise_value = noise.get_noise_3d(hex.q, hex.r, hex.s)
		elevation = correct_elevation(hex, elevation_noise_value)
		
		# humidity
		noise.fractal_octaves = 2
		#noise.frequency = 0.2
		noise.seed = noise_seed+1
		var humidity_noise_value = noise.get_noise_3d(hex.q, hex.r, hex.s)
		humidity = (humidity_noise_value / 2.0) + 0.5
		
		# temperature
		noise.fractal_octaves = 2
		#noise.frequency = 0.2
		noise.seed = noise_seed+2
		temperature = noise.get_noise_3d(hex.q, hex.r, hex.s)
		
		tile_info = TileInfo.new(
			elevation,
			humidity,
			temperature
		)
		
		hex_region.set_value(hex, tile_info)

func _init():
	generate_map()
	
func _ready():
	$HexMapCanvas.connect('draw', self.draw_hexes)
	$HexOverlayCanvas.connect('draw', self.draw_overlay)

func draw_hexes():
	for hex in self.hexes:
		var tile_info = hex_region.get_value(hex)
		
		var color_value: Color
		if tile_info.elevation <= 0.0:
			color_value = water_gradient.sample(-tile_info.elevation)
			
		else:
			#color_value = ground_gradient.sample(tile_info.elevation)
			color_value = tile_info.terrain_color
			
			
		$HexMapCanvas.draw_hex(hex, color_value)

func draw_overlay():
	if selected_hex != null:
		$HexOverlayCanvas.draw_hex(selected_hex, Color.ORANGE, 3, true)
		
	if cursor_hex != null and hex_region.has(cursor_hex):
		$HexOverlayCanvas.draw_debug_info(cursor_hex, hex_region.get_value(cursor_hex))	
		
	if path_line:
		$HexOverlayCanvas.draw_path(path_line)


func _process(_delta):
	var mouse_position = get_global_mouse_position()
	var new_cursor_hex = self.layout.position_to_hex(mouse_position).round()
	if not new_cursor_hex.equal(self.cursor_hex):
		self.cursor_hex = new_cursor_hex
		$HexOverlayCanvas.queue_redraw()
	
	if self.selected_hex != null and not self.cursor_hex.equal(self.selected_hex):
		self.path_line = self.layout.hex_line(self.cursor_hex, self.selected_hex)
	else:
		self.path_line = []
		
func _input(event):
	if event.is_action_pressed('ui_accept'):
		var _reload = get_tree().reload_current_scene()
	
	if event.is_action_pressed("select_hex"):
		selected_hex = cursor_hex
	
	
