extends Node2D

@onready
var layout = $HexLayout

var selected_hex: Hex
var cursor_hex: Hex

func draw_closed_line(corners: Array[Vector2], color: Color, width: float = -1.0, antialiased: bool = false):
	for i in len(corners) - 1:
		draw_line(corners[i], corners[i+1], color, width, antialiased)
	draw_line(corners[-1], corners[0], color, width, antialiased)

func draw_hex(h: Hex, color: Color, width: float = -1.0, antialiased: bool = false):
	var corners = layout.get_polygon_corners(h)
	draw_closed_line(corners, color, width, antialiased)
	
func _draw():
	var center = Hex.new(0, 0, 0)
	draw_hex(center, Color.CADET_BLUE)
	for i in range(6):
		var neighbor = center.get_neighbor(i)
		draw_hex(neighbor, Color.CADET_BLUE)
	
	if self.selected_hex != null:
		draw_hex(selected_hex, Color.ORANGE, 3, true)
		
	if self.cursor_hex != null:
		draw_hex(cursor_hex, Color.WHEAT, 2, true)
	
	

func _process(_delta):
	var mouse_position = get_global_mouse_position()
	var new_cursor_hex = layout.position_to_hex(mouse_position).round()
	if new_cursor_hex != self.cursor_hex:
		self.cursor_hex = new_cursor_hex
		queue_redraw()
		
func _input(event):
	if event.is_action_pressed('ui_accept'):
		self.selected_hex = self.cursor_hex
		queue_redraw()
	
	
