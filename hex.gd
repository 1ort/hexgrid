extends Object
class_name Hex

# In theory, i could inherit this class from Vector3i, but i wanted to save 
# params naming and prevent any possible conflicts.
# Nevertheless, i maintained compatibility with Vector3i via from_vector3i()
# and as_vector3i() methods

var q: int
var r: int
var s: int

const directions = [
	Vector3i(1, 0, -1), 
	Vector3i(1, -1, 0), 
	Vector3i(0, -1, 1), 
   	Vector3i(-1, 0, 1), 
	Vector3i(-1, 1, 0), 
	Vector3i(0, 1, -1)
]

func _init(q_: int, r_: int, s_: int):
	if not (q_ + r_ + s_ == 0):
		push_error('Invalid cube hex coordinates') 
	self.q = q_
	self.r = r_
	self.s = s_

static func from_axial(q_: int, r_: int) -> Hex:
	return Hex.new(q_, r_, -q_-r_)

static func from_vector3i(v: Vector3i):
	var res = Hex.new(v.x, v.y, v.z)
	return res

func as_vector3i() -> Vector3i:
	var res = Vector3i(self.q, self.r, self.s)
	return res	
	
func equal(other: Hex) -> bool:
	if not other is Hex:
		return false
	return self.q == other.q and self.r == other.r and self.s == other.s

func add(other: Hex) -> Hex:
	return Hex.new(
		self.q + other.q,
		self.r + other.r,
		self.s + other.s
	)

func subtract(other: Hex) -> Hex:
	return Hex.new(
		self.q - other.q,
		self.r - other.r,
		self.s - other.s
	)

func multiply(k: int) -> Hex:
	return Hex.new(
		self.q * k,
		self.r * k,
		self.s * k,
	)
	
func length() -> int:
	return int((abs(self.q) + abs(self.r) + abs(self.s)) / 2);
	
func distance_to(other: Hex) -> int:
	return self.subtract(other).length()

func get_direction(direction: int) -> Vector3i:
	var relative = directions[(6 + (direction % 6)) % 6]
	return relative

func get_neighbor(direction: int) -> Hex:
	var relative: Hex = Hex.from_vector3i(get_direction(direction))
	return self.add(relative)

func rotate_left() -> Hex:
	return Hex.new(-self.s, -self.q, -self.r)
	
func rotate_right() -> Hex:
	return Hex.new(-self.r, -self.s, -self.q)
