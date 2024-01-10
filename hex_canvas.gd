extends Node2D
class_name HexCanvas

@export
var layout: HexLayout = null

func draw_closed_line(corners: Array[Vector2], color: Color, width: float = -1.0, antialiased: bool = false):
	corners.append(corners[0])
	draw_polyline(corners, color, width, antialiased)

func draw_polygon_hex(h: Hex, color: Color):
	var corners = layout.get_polygon_corners(h)
	draw_polygon(corners, [color])

func draw_outline_hex(h: Hex, color: Color, width: float = -1.0, antialiased: bool = false):
	var corners = layout.get_polygon_corners(h)
	draw_closed_line(corners, color, width, antialiased)

func draw_outline_region(region: HexRegion, color: Color, width: float = -1.0):
	var corners: PackedVector2Array = []
	for hex in region.get_hexes():
		for direction in 6:
			if not region.has(hex.get_neighbor(direction)):
				corners.append_array(layout.get_border(hex, direction))
	draw_multiline(corners, color, width)

func draw_path(path: Array[Hex], color: Color, width: float = -1.0, antialiased: bool = false):
	var positions: Array[Vector2] = []
	for hex in path:
		positions.append(layout.hex_to_position(hex))
	draw_polyline(positions, color, width, antialiased)
	
