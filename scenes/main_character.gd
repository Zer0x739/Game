extends CharacterBody2D

@export var SPEED = 300.0
@export var jump_height = 100.0
@export var jump_time_to_peak = 0.5
@export var jump_time_to_descent = 0.5
var jumps_left = 0

@onready var jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var sprite_2d = $Sprite2D
@onready var jump_sound = $jump_sound
@onready var walk_sound = $walk_sound

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _physics_process(delta):
	# Animations
	if (velocity.x > 1 or velocity.x < -1):
		sprite_2d.animation = "running"
		if not walk_sound.is_playing():
			walk_sound.play()
	else:
		sprite_2d.animation = "default"
		walk_sound.stop()

	# Add the gravity.
	velocity.y += get_gravity() * delta

	if is_on_floor():
		jumps_left = 2

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
			velocity.y = jump_velocity
			jumps_left =  jumps_left - 1
			jump_sound.play()

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 20)

	move_and_slide()

	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft

func is_moving() -> bool:
	return velocity.x != 0 or velocity.y != 0  
