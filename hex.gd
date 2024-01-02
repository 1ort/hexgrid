extends Object
class_name Hex

var q: int
var r: int
var s: int

static var directions = [
	Hex.new(1, 0, -1), 
	Hex.new(1, -1, 0), 
	Hex.new(0, -1, 1), 
   	Hex.new(-1, 0, 1), 
	Hex.new(-1, 1, 0), 
	Hex.new(0, 1, -1)
]

func _init(q_: int, r_: int, s_: int):
	if not (q_ + r_ + s_ == 0):
		push_error('Invalid cube hex coordinates') 
	self.q = q
	self.r = r
	self.s = s

static func from_axial(q_: int, r_: int) -> Hex:
	return Hex.new(q_, r_, -q_-r_)


func equal(other: Hex) -> bool:
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

static func get_direction(direction: int) -> Hex:
	return directions[(6 + (direction % 6)) % 6]

func get_neighbor(direction: int) -> Hex:
	return self.add(self.get_direction(direction))
