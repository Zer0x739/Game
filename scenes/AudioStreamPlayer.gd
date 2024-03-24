extends Node2D

var songs_folder = "res://song_folder/"
var current_song = -1
var song_audiostream = null

# Load a random song when the scene is added to the scene tree
func _ready():
	load_random_song()

# Unload the current song and load a new random song
func load_random_song():
	if song_audiostream != null:
		song_audiostream.stop()
		song_audiostream.queue_free()
		song_audiostream = null

	var song_files = get_tree().get_files_in_dir(songs_folder)
	var song_count = song_files.size()
	if song_count == 0:
		print("No songs found in", songs_folder)
		return

	# Generate a random index that is not the same as the current song index
	var random_index = randi() % song_count
	while random_index == current_song:
		random_index = randi() % song_count

	current_song = random_index
	var song_file = songs_folder + song_files[current_song]
	print("Loading song", song_file)
	song_audiostream = AudioStreamPlayer.new()
	add_child(song_audiostream)
	song_audiostream.stream = AudioStream.new()
	song_audiostream.stream.load(song_file)
	song_audiostream.play()
	song_audiostream.connect("stream_finished", self, "load_random_song")
