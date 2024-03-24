extends AudioStreamPlayer

@onready var character = $".."

func _physics_process(_delta):
	# Check if the character is moving and not on the floor
	if character.is_moving() and not character.is_on_floor():
		# Play the audio stream if it's not already playing
		if playing:
			play()
	else:
		# Stop the audio stream if it's playing
		if not playing:
			stop()
