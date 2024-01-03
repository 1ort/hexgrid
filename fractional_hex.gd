extends Object
class_name FracHex

var q: float
var r: float
var s: float

func _init(q_: float, r_: float, s_: float):
	self.q = q_
	self.r = r_
	self.s = s_

func round():
	var q_ = int(round(self.q))
	var r_ = int(round(self.r))
	var s_ = int(round(self.s))
	var q_diff = abs(q_ - self.q)
	var r_diff = abs(r_ - self.r)
	var s_diff = abs(s_ - self.s)
	if q_diff > r_diff and r_diff > s_diff:
		q_ = -r_ - s_
	elif r_diff > s_diff:
		r_ = -q_ - s_
	else:
		s_ = -q_ - r_
	return Hex.new(q_, r_, s_)
