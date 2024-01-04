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

var noise = FastNoiseLite.new()

@export
var water_gradient: Gradient
@export
var ground_gradient: Gradient	

func get_hex_noise(hex) -> float:
	return noise.get_noise_3d(hex.q, hex.r, hex.s)

func get_hex_elevation(hex: Hex):
	var elevation = get_hex_noise(hex)
	var distance = float(hex.distance_to(Hex.new(0,0,0)))
	var max_distance = float(hex_radius)
	var distance_k = 1.0 / max_distance
	
	var d = distance_k * distance
	elevation = lerp(elevation, 1-(d*2), elevation_k)
	
	elevation = lerp(elevation, sign(elevation), abs(elevation)*0.4)
	
	return elevation


func generate_hex_noise():
	var rng = RandomNumberGenerator.new()
	noise.seed = rng.randi_range(0, 500)
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_octaves = 3
	noise.frequency = 0.05
	
	for hex in hex_region.get_hexes():
		var elevation = get_hex_elevation(hex)
		hex_region.set_value(hex, elevation)

func _init():
	generate_hex_noise()
	
func _ready():
	$HexMapCanvas.connect('draw', self.draw_hexes)
	$HexOverlayCanvas.connect('draw', self.draw_overlay)

func draw_hexes():
	for hex in self.hexes:
		var noise_value = hex_region.get_value(hex)
		
		var color_value: Color
		if noise_value <= 0.0:
			color_value = water_gradient.sample(-noise_value)
		else:
			color_value = ground_gradient.sample(noise_value)
		
		$HexMapCanvas.draw_hex(hex, color_value)

func draw_overlay():
	if self.selected_hex != null:
		$HexOverlayCanvas.draw_hex(selected_hex, Color.ORANGE, 3, true)
		
	if self.cursor_hex != null:
		$HexOverlayCanvas.draw_hex(cursor_hex, Color.WHEAT, 2, true)
		
	if self.path_line:
		$HexOverlayCanvas.draw_path(self.path_line)


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
	
	
