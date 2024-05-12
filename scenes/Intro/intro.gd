extends Node

@export_file("*.tscn") var game_scene_path : String

func _on_animation_player_animation_finished(_anim_name):
	SceneLoader.load_scene(game_scene_path)

func _on_skip_button_pressed():
	$AnimationPlayer.queue_free()
	SceneLoader.load_scene(game_scene_path)
