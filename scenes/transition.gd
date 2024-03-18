extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	$AnimationPlayer.play_backwards('dissolve')
