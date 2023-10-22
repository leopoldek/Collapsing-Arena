extends KinematicBody2D

#const HitWallSound = preload("hit_wall.wav")

const SPEED = 70.0

var damage = 0.0
var expand_map = false

func _process(delta):
	var collide = move_and_collide(Vector2(cos(rotation) * SPEED, sin(rotation) * SPEED))
	if collide:
		var object = collide.collider
		
		if object.collision_layer & Map.LAYER_WALL != 0:
			if expand_map:
				#Map.play_sound(HitWallSound, position, -15)
				Map.push(position, 0.4)
				if collision_mask & Map.LAYER_ENEMY != 0:
					Map.score += 2
		#elif object.has_method("hit"):
		else:
			object.hit(damage)
		
		queue_free()