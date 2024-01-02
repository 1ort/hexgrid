@tool
extends Node2D

@onready
var layout = $HexLayout

func draw_closed_line(corners: Array[Vector2], color: Color, width: float = -1.0, antialiased: bool = false):
	for i in len(corners) - 1:
		draw_line(corners[i], corners[i+1], color, width, antialiased)
	draw_line(corners[-1], corners[0], color, width, antialiased)

func _draw_hex(h: Hex):
	var corners = layout.get_polygon_corners(h)
	draw_closed_line(corners, Color.CADET_BLUE)
	

func _draw():
	var center = Hex.new(0, 0, 0)
	_draw_hex(center)
	for i in range(6):
		var neighbor = center.get_neighbor(i)
		_draw_hex(neighbor)

func _process(_delta):
	if not Engine.is_editor_hint():
		return
	queue_redraw()
