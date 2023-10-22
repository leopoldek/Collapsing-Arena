extends Polygon2D

func _ready():
	var pool = PoolVector2Array()
	pool.resize(Map.PRECISION)
	polygon = pool
	pool.resize(Map.PRECISION + 1)
	$Border.points = pool

func _process(delta):
	var i = 0
	for point in Map.points:
		polygon[i] = point.position
		$Border.points[i] = point.position
		i += 1
	$Border.points[Map.PRECISION] = Map.points[0].position