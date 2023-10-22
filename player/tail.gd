extends Line2D

const FRAMERATE = 60.0
const DELTA_FRAMERATE = 1.0 / FRAMERATE

var accumulator = 0.0

func _process(delta):
	accumulator += delta
	if accumulator > DELTA_FRAMERATE:
		accumulator = 0.0
	else:
		return
	
	# Shift points back
	var i = points.size() - 1
	while i > 0:
		points[i] = points[i - 1]
		i -= 1
	
	# Modify first point
	points[0] = get_parent().get_parent().position