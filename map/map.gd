extends Node

enum Layer{
	LAYER_PLAYER = 1 << 0
	LAYER_WALL = 1 << 1
	LAYER_BULLET = 1 << 2
	LAYER_ENEMY = 1 << 3
}

enum Stage{
	STAGE_MENU
	STAGE_GAME
	STAGE_OVER
}

const MIN_DISTANCE = 500.0
const MAX_DISTANCE = 10000.0
const RANGE = MAX_DISTANCE - MIN_DISTANCE
const PRECISION = 128 * 3
const ANGLE_STEP = 2 * PI / PRECISION

const Wall = preload("wall.tscn")
const Point = preload("point.gd")
const Background = preload("background.tscn")
const Bullet = preload("res://bullet/bullet.tscn")

var collapse_speed = 0.08

var points
var walls

signal new_stage()
var stage

var player

var score

func _ready():
	get_tree().paused = true
	
	randomize()
	
	points = []
	for i in range(PRECISION):
		var angle = ANGLE_STEP * i
		points.push_back(Point.new(angle))
	
	walls = []
	for i in range(PRECISION):
		var start = points[i]
		var end = points[(i + 1) % PRECISION]
		var wall = Wall.instance()
		wall.start = start
		wall.end = end
		walls.push_back(wall)
	
	for point in points:
		add_child(point)
	
	for wall in walls:
		add_child(wall)
	
	add_child(Background.instance())
	
	score = 0

func new_game():
	for child in get_children():
		child.free()
	_ready()

func push(location, max_angle):
	var location_angle = location.angle()
	# For some reason floor and ceil return floats :(
	var min_index = int(floor((location_angle - max_angle) / ANGLE_STEP))
	var max_index = int(ceil((location_angle + max_angle) / ANGLE_STEP))
	var delta_index = max_index - min_index
	for i in range(delta_index):
		var point = points[min_index + i]
		var delta_angle = location.angle_to(point.position)
		if delta_angle > max_angle: continue
		point.push(0.02 * (cos(delta_angle * PI / max_angle) * 0.5 + 0.5))

func get_vector(angle):
	var point_angle_index = angle / ANGLE_STEP
	var floor_index = int(point_angle_index)
	var ceil_index = int(point_angle_index + 1)
	point_angle_index -= floor_index
	return points[floor_index].position * (1.0 - point_angle_index) + points[ceil_index].position * point_angle_index

func is_inside(point):
	return get_vector(point.angle()).length_squared() > point.length_squared()

func near_player(point, distance):
	return (player.position - point).length_squared() <= distance * distance

func create_bullet(friendly, start, angle, damage = 0.0, expand_map = false):
	var bullet = Bullet.instance()
	bullet.position = start
	bullet.rotation = angle
	bullet.damage = damage
	bullet.expand_map = expand_map
	if friendly:
		bullet.collision_mask = LAYER_WALL | LAYER_ENEMY
	else:
		bullet.collision_mask = LAYER_WALL | LAYER_PLAYER
	add_child(bullet)
	return bullet

func random_point():
	return Vector2(rand_range(-MAX_DISTANCE, MAX_DISTANCE), rand_range(-MAX_DISTANCE, MAX_DISTANCE))

func set_to_menu():
	new_game()
	stage = STAGE_MENU
	emit_signal("new_stage")

func set_to_game():
	stage = STAGE_GAME
	get_tree().paused = false
	emit_signal("new_stage")

func set_to_over():
	stage = STAGE_OVER
	get_tree().paused = true
	emit_signal("new_stage")

func play_sound(sound, position, volume = 0):
	var stream = AudioStreamPlayer2D.new()
	stream.stream = sound
	stream.position = position
	stream.volume_db = volume
	stream.connect("finished", stream, "queue_free")
	add_child(stream)