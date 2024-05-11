extends Node

@export_file("*.tscn") var game_scene_path : String

func _on_animation_player_animation_finished(anim_name):
	print("animation finished!")
	SceneLoader.load_scene(game_scene_path)
