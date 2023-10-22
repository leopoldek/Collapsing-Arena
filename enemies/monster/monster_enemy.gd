extends KinematicBody2D

const MAX_HEALTH = 240.0
const SPEED = 80.0

var health = MAX_HEALTH

func _ready():
	set_physics_process(false)
	$GunTop.angle = deg2rad(270)
	$GunLeft.angle = deg2rad(180)
	#$GunRight.angle = 0
	$GunBot.angle = deg2rad(90)

func _physics_process(delta):
	var angle = get_angle_to(Map.player.position)
	
	var collide = move_and_collide(Vector2(cos(angle), sin(angle)) * SPEED * delta)
	if collide:
		var object = collide.collider
		if object.collision_layer & Map.LAYER_BULLET == 0:
			queue_free()

func hit(damage):
	$HitSound.play()
	health -= damage
	
	if health <= 0.0:
		Map.score += 400
		queue_free()
	else:
		var hit_timer = get_tree().create_timer(0.1)
		hit_timer.connect("timeout", $Sprite, "set", ["modulate", Color(1, 1, 1)], CONNECT_ONESHOT)
		$Sprite.modulate = Color(20, 2, 2)

func start():
	set_physics_process(true)
	$GunTop.shoot = true
	$GunLeft.shoot = true
	$GunRight.shoot = true
	$GunBot.shoot = true