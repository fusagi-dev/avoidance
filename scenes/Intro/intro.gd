extends Node

@export_file("*.tscn") var game_scene_path : String

signal animation_finished

func _on_animation_player_animation_finished(anim_name):
	emit_signal("animation_finished")
	#SceneLoader.load_scene(game_scene_path)
