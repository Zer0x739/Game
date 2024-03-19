extends Control

@onready var main =  $"../../../"

func _on_resumebutton_pressed():
	main.pauseMenu()

func _on_quitbutton_pressed():
	get_tree().quit()
