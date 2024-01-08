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
	world_generator.elevation_noise.fractal_octaves = 4
	world_generator.elevation_noise.frequency = 0.03
	world_generator.humidity_noise.fractal_octaves = 2
	world_generator.humidity_noise.frequency = 0.02
	
	hex_region = world_generator.generate_map()
	hexes = hex_region.get_hexes()
	$HexMapCanvas.queue_redraw()


func _ready():
	$HexMapCanvas.connect('draw', self.draw_hexes)
	$HexOverlayCanvas.connect('draw', self.draw_overlay)
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
		$HexOverlayCanvas.queue_redraw()
	
	if self.selected_hex != null and not self.cursor_hex.equal(self.selected_hex):
		self.path_line = self.layout.hex_line(self.cursor_hex, self.selected_hex)
	else:
		self.path_line = []
		
func _input(event):
	if event.is_action_pressed('ui_accept'):
		generate_map()
		
		#var _reload = get_tree().reload_current_scene()
	
	if event.is_action_pressed("select_hex"):
		selected_hex = cursor_hex
	
	
