extends KinematicBody2D

const MAX_HEALTH = 40.0
const SPEED = 500.0
const DAMAGE = 20.0

var health = MAX_HEALTH

func _ready():
	rotation = Map.player.position.angle_to_point(position)

func _physics_process(delta):
	var desired_angle = Map.player.position.angle_to_point(position)
	
	var diff = desired_angle - rotation
	diff = fmod(diff + 180, 360) - 180
	rotation += diff * min(1, delta * 0.7)
	
	var collide = move_and_collide(Vector2(cos(rotation), sin(rotation)) * SPEED * delta)
	if collide:
		var object = collide.collider
		if object.collision_layer & Map.LAYER_BULLET == 0:
			if object.collision_layer & Map.LAYER_PLAYER != 0:
				object.hit(DAMAGE)
			queue_free()

func hit(damage):
	$HitSound.play()
	health -= damage
	if health <= 0.0:
		Map.score += 70
		queue_free()