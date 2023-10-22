extends StaticBody2D

var start
var end

func _ready():
	assert(start != null and end != null)
	update_position()

func _process(delta):
	update_position()

func update_position():
	position = (start.position + end.position) * 0.5
	var difference = end.position - start.position
	rotation = difference.angle()
	$Collider.shape.height = difference.length()