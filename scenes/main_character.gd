extends CharacterBody2D

@export var SPEED = 300.0
@export var jump_height = 100.0
@export var jump_time_to_peak = 0.5
@export var jump_time_to_descent = 0.5
var max_jumps = 1
var remaining_jumps = 0

var coyote_jump_duration = 0.2 # duration in seconds

@onready var jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var sprite_2d = $Sprite2D
@onready var jump_sound = $jump_sound
@onready var walk_sound = $walk_sound
@onready var coyote_jump_timer = $CoyoteJumpTimer

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	if remaining_jumps < max_jumps:
		velocity.y = jump_velocity
		remaining_jumps += 1
		coyote_jump_timer.start(coyote_jump_duration)
		jump_sound.play()

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
	if not is_on_floor():
		velocity.y += get_gravity() * delta
		sprite_2d.animation = "jumping"

	# Handle Jump.
	if is_on_floor() or coyote_jump_timer.time_left > 0.2:
		if Input.is_action_just_pressed("jump") and remaining_jumps < max_jumps:
			jump()
	elif not is_on_floor():
		if Input.is_action_just_pressed("jump") and remaining_jumps < max_jumps:
			jump()

	if is_on_floor():
		remaining_jumps = 0

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 20)

	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_jump_timer.start()

	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft

func is_moving() -> bool:
	return velocity.x != 0 or velocity.y != 0
