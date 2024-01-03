extends Node2D

@onready
var layout = $HexLayout

var selected_hex: Hex
var cursor_hex: Hex
var path_line: Array[Hex]

var default_font = ThemeDB.fallback_font
var default_font_size = ThemeDB.fallback_font_size

var hex_region = HexRegion.new_hexagon(3, Hex.new(0, 0, 0))

func draw_closed_line(corners: Array[Vector2], color: Color, width: float = -1.0, antialiased: bool = false):
	for i in len(corners) - 1:
		draw_line(corners[i], corners[i+1], color, width, antialiased)
	draw_line(corners[-1], corners[0], color, width, antialiased)

func draw_hex(h: Hex, color: Color, width: float = -1.0, antialiased: bool = false):
	var corners = layout.get_polygon_corners(h)
	draw_closed_line(corners, color, width, antialiased)

	draw_string(default_font, layout.hex_to_position(h), "%d, %d, %d" % [h.q, h.r, h.s], HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)

func draw_path(path: Array[Hex]):
	for hex in path:
		draw_circle(layout.hex_to_position(hex), 8, Color.CADET_BLUE)
	
func _draw():
	if self.path_line:
		draw_path(self.path_line)
	#var center = Hex.new(0, 0, 0)
	#draw_hex(center, Color.CADET_BLUE)
	for hex in self.hex_region.get_hexes():
		#var neighbor = center.get_neighbor(i)
		draw_hex(hex, Color.CADET_BLUE)
	
	if self.selected_hex != null:
		draw_hex(selected_hex, Color.ORANGE, 3, true)
		
	if self.cursor_hex != null:
		draw_hex(cursor_hex, Color.WHEAT, 2, true)

func _process(_delta):
	var mouse_position = get_global_mouse_position()
	var new_cursor_hex = self.layout.position_to_hex(mouse_position).round()
	if not new_cursor_hex.equal(self.cursor_hex):
		self.cursor_hex = new_cursor_hex
		queue_redraw()
	
	if self.selected_hex != null and not self.cursor_hex.equal(self.selected_hex):
		self.path_line = self.layout.hex_line(self.cursor_hex, self.selected_hex)
	else:
		self.path_line = []
		
func _input(event):
	if event.is_action_pressed('ui_accept'):
		self.selected_hex = self.cursor_hex
		queue_redraw()
	
	
