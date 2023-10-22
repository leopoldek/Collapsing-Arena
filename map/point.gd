extends Node

var fraction = 0.2
var angle

var position

var pushers = []

func _init(p_angle):
	angle = p_angle
	update_position()

func _process(delta):
	var amount = min(1, 7.0 * delta)
	var i = pushers.size() - 1
	while i >= 0:
		var amount_pushing = amount * pushers[i]
		fraction += amount_pushing
		if amount_pushing < 0.00001:
			pushers.remove(i)
		else:
			pushers[i] -= amount_pushing
		i -= 1
	
	fraction -= Map.collapse_speed * fraction * delta
	fraction = clamp(fraction, 0, 1)
	update_position()

func push(amount):
	pushers.push_back(amount)

func get_distance(frac):
	return range_lerp(frac, 0, 1, Map.MIN_DISTANCE, Map.MAX_DISTANCE)

func get_fraction(dist):
	return range_lerp(sqrt(dist), Map.MIN_DISTANCE, Map.MAX_DISTANCE, 0, 1)

func update_position():
	var distance = get_distance(fraction)
	position = Vector2(cos(angle) * distance, sin(angle) * distance)