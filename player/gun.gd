extends Node2D

export(float, 0, 100) var firerate = 0.1
export(float, 0, 3.14) var spread = deg2rad(2)
export(float, 0, 1000) var min_damage = 20.0
export(float, 0, 1000) var max_damage = 45.0

export(bool) var friendly = false
export(bool) var expand_map = false

var accumulator = 0.0
var angle = 0.0

var shoot = false

signal fired(bullet)

func _process(delta):
	accumulator += delta
	
	if not shoot and accumulator > firerate:
		accumulator = firerate
	
	if shoot:
		while accumulator >= firerate:
			accumulator -= firerate
			fire()

func fire():
	var bullet = Map.create_bullet(
			friendly, global_position,
			angle + rand_range(-spread, spread),
			rand_range(min_damage, max_damage),
			expand_map
	)
	emit_signal("fired", bullet)