extends KinematicBody2D

const SPEED = 250.0

var health = 100.0

func _ready():
	$Gun.shoot = true
	rotation_degrees = rand_range(0, 360)

func _process(delta):
	$Gun.angle = rotation

func _physics_process(delta):
	var desired_angle = Map.player.position.angle_to_point(position)
	
	var diff = desired_angle - rotation
	diff = fmod(diff + 180, 360) - 180
	rotation += diff * min(1, 1.3 * delta)
	
	var collide = move_and_collide(Vector2(cos(rotation), sin(rotation)) * SPEED * delta)
	if collide:
		var object = collide.collider
		if object.collision_layer & Map.LAYER_BULLET == 0:
			queue_free()

func hit(damage):
	$HitSound.play()
	health -= damage
	
	if health <= 0:
		queue_free()
		Map.score += 100
	else:
		var hit_timer = get_tree().create_timer(0.1)
		hit_timer.connect("timeout", $Sprite, "set", ["modulate", Color(1, 1, 1)], CONNECT_ONESHOT)
		$Sprite.modulate = Color(20, 2, 2)