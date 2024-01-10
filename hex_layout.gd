extends Node2D
class_name HexLayout

class HexLayoutOrientation:
	extends Object
	
	var f0: float
	var f1: float
	var f2: float
	var f3: float
	
	var b0: float
	var b1: float
	var b2: float
	var b3: float
	
	var start_angle: float
	var borders: Array[Array]
	
	
	func _init(
		f0_: float, f1_: float, f2_: float, f3_: float, 
		b0_: float, b1_: float, b2_: float, b3_: float, 
		start_angle_: float,
		borders_: Array[Array]):
		self.f0 = f0_
		self.f1 = f1_
		self.f2 = f2_
		self.f3 = f3_
		self.b0 = b0_
		self.b1 = b1_
		self.b2 = b2_
		self.b3 = b3_
		self.start_angle = start_angle_
		self.borders = borders_

#region orientations
static var POINTY = HexLayoutOrientation.new(
	sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0,
	sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0,
	0.5, [[5, 6], [4, 5], [3, 4], [2, 3], [1, 2], [0, 1]]
)
static var FLAT = HexLayoutOrientation.new(
	3.0 / 2.0, 0.0, sqrt(3.0) / 2.0, sqrt(3.0),
	2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0,
	0.0, [[0, 1], [5, 6], [4, 5], [3, 4], [2, 3], [1, 2]]
)
#endregion

@export_enum('Pointy', 'Flat')
var _orientation: String
@export
var hex_size: Vector2
@export
var origin: Vector2

func get_orientation() -> HexLayoutOrientation:
	return FLAT if self._orientation == 'Flat' else POINTY

func _init():
	pass

func hex_to_position(h: Hex) -> Vector2:
	var M = self.get_orientation()
	var x: float = (M.f0 * h.q + M.f1 * h.r) * self.hex_size.x;
	var y: float = (M.f2 * h.q + M.f3 * h.r) * self.hex_size.y;
	return Vector2(x + self.origin.x, y + self.origin.y)

func position_to_hex(p: Vector2):
	var M = self.get_orientation()
	var pt = Vector2(
		(p.x - self.origin.x) / self.hex_size.x,
		(p.y - self.origin.y) / self.hex_size.y
		)
	var q = M.b0 * pt.x + M.b1 * pt.y
	var r = M.b2 * pt.x + M.b3 * pt.y
	return FracHex.new(q, r, -q - r)

func hex_corner_offset(corner: int) -> Vector2:
	var angle = 2.0 * PI * (self.get_orientation().start_angle + corner) / 6
	return Vector2(self.hex_size.x * cos(angle), self.hex_size.y * sin(angle))

func get_polygon_corners(h: Hex) -> PackedVector2Array:
	var corners: PackedVector2Array = []
	var center = self.hex_to_position(h)
	for i in 6:
		var offset = self.hex_corner_offset(i)
		corners.append(Vector2(
			center.x + offset.x,
			center.y + offset.y
		))
	return corners

func get_border(h: Hex, direction: int) -> PackedVector2Array:
	var corners = get_orientation().borders[direction]
	
	var res: PackedVector2Array = []
	var center = self.hex_to_position(h)
	for i in corners:
		var offset = self.hex_corner_offset(i)
		res.append(Vector2(
			center.x + offset.x,
			center.y + offset.y
		))
	return res
	
func hex_lerp(a: Hex, b: Hex, t: float) -> FracHex:
	return FracHex.new(
		lerp(a.q, b.q, t),
		lerp(a.r, b.r, t),
		lerp(a.s, b.s, t)
	)

func hex_line(a: Hex, b: Hex) -> Array[Hex]:
	var n = a.distance_to(b)
	var results: Array[Hex] = []
	var step: float = 1.0 / max(n, 1)
	for i in n+1:
		results.append(self.hex_lerp(a, b, step*i).round())
	return results
		
