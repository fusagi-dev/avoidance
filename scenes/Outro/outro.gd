extends Node

@export_file("*.tscn") var game_scene_path : String

signal animation_finished

func _on_skip_button_pressed():
	emit_signal("animation_finished")


func _on_animation_player_animation_finished(_anim_name):
	emit_signal("animation_finished")
