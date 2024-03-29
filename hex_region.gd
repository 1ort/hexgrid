extends Object
class_name HexRegion

var _hexes: Dictionary

#region dict functions
func add(h: Hex):
	self.set_value(h, null)

func set_value(h: Hex, value: Variant):
	self._hexes[h.as_vector3i()] = value
	
func get_value(h: Hex) -> Variant:
	return self._hexes[h.as_vector3i()]
	
func remove(h: Hex):
	self._hexes.erase(h.as_vector3i())

func has(h: Hex) -> bool:
	return self._hexes.has(h.as_vector3i())
	
func merge(other: HexRegion, overwrite: bool = false):
	_hexes.merge(other._hexes, overwrite)
#endregion

func get_hexes() -> Array[Hex]:
	var hexes: Array[Hex] = []
	for hex_vec in self._hexes.keys():
		hexes.append(Hex.from_vector3i(hex_vec))
	return hexes


static func new_parallelogram(mode: String, q0: int, q1: int, r0: int, r1: int, s0: int, s1: int) -> HexRegion:
	var region = HexRegion.new()
	if mode not in ['qr', 'qs', 'rs']:
		push_error("mode value must be one of 'qr', 'qs', 'rs'")
		return region
	if mode == 'qr':
		for q in range(q0, q1+1):
			for r in range(r0, r1+1):
				region.add(Hex.new(q, r, -q-r))
	elif mode == 'qs':
		for q in range(q0, q1+1):
			for s in range(s0, s1+1):
				region.add(Hex.new(q, -q-s, s))
	else:
		for r in range(r0, r1+1):
			for s in range(s0, s1+1):
				region.add(Hex.new(-r-s, r, s))
	return region

static func new_hexagon(radius: int, center: Hex = null) -> HexRegion:
	if center == null:
		center = Hex.new(0, 0, 0)
	
	var region = HexRegion.new()
	for q in range(-radius, radius+1):
		var r1 = max(-radius, -q - radius)
		var r2 = min(radius, -q + radius)
		for r in range(r1, r2+1):
				region.add(Hex.new(q+center.q, r+center.r, -q-r+center.s))
	return region
	
	
	
