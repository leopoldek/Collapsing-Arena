extends KinematicBody2D

const MAX_HEALTH = 100.0
const MAX_POWER = 100.0

const FIRE_COST = 5.0
const POWER_REGEN = 35.0

const MIN_SPEED = 200.0
const MAX_SPEED = 1500.0

const ACCELERATION = 350.0
const TURN_RATE = 200.0

var speed = MIN_SPEED
var angle = 0.0

var health = MAX_HEALTH
var died = false

var power = MAX_POWER
var exhausted = false

func _init():
	Map.player = self

func _ready():
	$Gun.connect("fired", self, "fired")

func _process(delta):
	if health <= 0 and not died:
		$Died/DiedAnimation.play("died")
		$AimIndicator.visible = false
		$AngleIcon.visible = false
		get_tree().paused = true
		$Died/DiedAnimation.connect("animation_finished", self, "game_over")
		$Died/DiedSound.play()
		died = true
	else:
		health += 1.0 * delta
		health = min(MAX_HEALTH, health)
	
	var acceleration = ACCELERATION * delta
	var turn_rate = TURN_RATE * delta
	
	if Input.is_action_pressed("accelerate"):
		speed += acceleration
	if Input.is_action_pressed("decelerate"):
		speed -= acceleration
	if Input.is_action_pressed("turn_left"):
		angle -= turn_rate
	if Input.is_action_pressed("turn_right"):
		angle += turn_rate
	
	speed = clamp(speed, MIN_SPEED, MAX_SPEED)
	
	var angle_radians = deg2rad(angle)
	rotation = angle_radians
	var collide = move_and_collide(Vector2(cos(angle_radians), sin(angle_radians)) * speed * delta)
	if collide:
		var object = collide.collider
		if object.collision_layer & Map.LAYER_BULLET == 0:
			health = 0
	
	var cursor_angle = (get_global_mouse_position() - position).angle()
	$AimIndicator.global_rotation = cursor_angle
	
	power += POWER_REGEN * delta
	if power >= MAX_POWER: exhausted = false
	power = min(MAX_POWER, power)
	
	$Gun.shoot = Input.is_action_pressed("shoot") and not exhausted
	$Gun.angle = cursor_angle

func hit(damage):
	health -= damage
	$HitSound.play()

func game_over(anim):
	Map.set_to_over()

func fired(bullet):
	$GunSound.play()
	power -= 5.0
	if power < 0.0:
		exhausted = true