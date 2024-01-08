extends Node

@onready
var layout = $HexLayout

var selected_hex: Hex
var cursor_hex: Hex
var path_line: Array[Hex]

var hex_region: HexRegion
var hexes: Array[Hex]

@export
var water_gradient: Gradient


func generate_map():
	var world_generator = HexWorldGenerator.new()
	var generator_settings = $GeneratorSettingsWindow.get_settings()
	world_generator.world_seed = generator_settings['seed']
	world_generator.world_radius = generator_settings['size']
	
	world_generator.elevation_k = generator_settings['elevation_correction']
	world_generator.elevation_noise.fractal_octaves = generator_settings['elevation_octaves']
	world_generator.elevation_noise.frequency = generator_settings['elevation_frequency']
	world_generator.elevation_noise.fractal_lacunarity = generator_settings['elevation_lacunarity']
	world_generator.humidity_noise.fractal_octaves = generator_settings['humidity_octaves']
	world_generator.humidity_noise.frequency = generator_settings['humidity_frequency']
	world_generator.humidity_noise.fractal_lacunarity = generator_settings['humidity_lacunarity']
	
	
	
	hex_region = world_generator.generate_map()
	hexes = hex_region.get_hexes()
	$HexMapCanvas.queue_redraw()


func _ready():
	$HexMapCanvas.connect('draw', self.draw_hexes)
	$HexOverlayCanvas.connect('draw', self.draw_overlay)
	$GeneratorSettingsWindow.connect('generate', self.generate_map)
	generate_map()
	
func draw_hexes():
	for hex in self.hexes:
		var tile_info = hex_region.get_value(hex)
		
		var color_value: Color
		if tile_info.elevation <= 0.0:
			color_value = water_gradient.sample(-tile_info.elevation)
			
		else:
			color_value = tile_info.terrain_color
			
		$HexMapCanvas.draw_hex(hex, color_value)

func draw_overlay():
	if selected_hex != null:
		$HexOverlayCanvas.draw_hex(selected_hex, Color.ORANGE)
		
	if cursor_hex != null and hex_region.has(cursor_hex):
		$HexOverlayCanvas.draw_debug_info(cursor_hex, hex_region.get_value(cursor_hex))	
		
	if path_line:
		$HexOverlayCanvas.draw_path(path_line)


func _process(_delta):
	var mouse_position = self.layout.get_global_mouse_position()
	var new_cursor_hex = self.layout.position_to_hex(mouse_position).round()
	if not new_cursor_hex.equal(self.cursor_hex):
		self.cursor_hex = new_cursor_hex
	
	if self.selected_hex != null and not self.cursor_hex.equal(self.selected_hex):
		self.path_line = self.layout.hex_line(self.cursor_hex, self.selected_hex)
	else:
		self.path_line = []
	
	$HexOverlayCanvas.queue_redraw()


func _unhandled_input(event):
	#if event.is_action_pressed('ui_accept'):
		#generate_map()
	
	if event.is_action_pressed("select_hex"):
		if selected_hex != null and selected_hex.equal(cursor_hex):
			selected_hex = null
		else:
			selected_hex = cursor_hex
	
	
