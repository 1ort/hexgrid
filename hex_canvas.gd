extends Node2D
class_name HexCanvas

@export
var layout: HexLayout = null

func draw_closed_line(corners: Array[Vector2], color: Color, width: float = -1.0, antialiased: bool = false):
	for i in len(corners) - 1:
		draw_line(corners[i], corners[i+1], color, width, antialiased)
	draw_line(corners[-1], corners[0], color, width, antialiased)


func draw_hex(h: Hex, color: Color, width: float = -1.0, antialiased: bool = false):
	var corners = layout.get_polygon_corners(h)
	draw_polygon(corners, [color])
	#draw_closed_line(corners, color + Color.WHITE * 0.5, width, antialiased)

func draw_path(path: Array[Hex]):
	for hex in path:
		draw_circle(layout.hex_to_position(hex), 16, Color.CADET_BLUE)

func draw_debug_info(hex: Hex, tile_info: TileInfo):
	var default_font = ThemeDB.fallback_font
	var font_size = (layout.hex_size).x / 4
	
	var corners = layout.get_polygon_corners(hex)
	draw_closed_line(corners, Color.WHITE)
	var hex_pos = layout.hex_to_position(hex)
	draw_string(
		default_font, 
		hex_pos, 
		"e: %f \nh: %f \nt: %f" % [
			tile_info.elevation, 
			tile_info.humidity, 
			tile_info.temperature
			],
		 HORIZONTAL_ALIGNMENT_LEFT, 
		-1,
		font_size,
)
	
