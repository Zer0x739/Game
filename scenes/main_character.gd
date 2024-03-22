extends CharacterBody2D

@export var SPEED = 300.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var sprite_2d = $Sprite2D
@onready var jumpSound = $jump_sound
@onready var walkSound = $walk_sound

var max_jumps = 1
var remaining_jumps = 0

func get_gravity() -> float:
	if jump_height < 0.1:
		print("jump_height nesmi byt mensi nez 0.1")
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	if remaining_jumps < max_jumps:
		velocity.y = jump_velocity
		remaining_jumps += 1

func _physics_process(delta):
	# Animations
	if (velocity.x > 1 or velocity.x <-1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"
		walkSound.play()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity() * delta
		sprite_2d.animation = "jumping"

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and remaining_jumps < max_jumps:
		jump()
		jumpSound.play()
	elif Input.is_action_just_pressed("jump") and remaining_jumps <= max_jumps:
		print(remaining_jumps)
		pass

	if is_on_floor():
		remaining_jumps = 0
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 20)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft

func is_moving():
	return velocity != Vector2()
