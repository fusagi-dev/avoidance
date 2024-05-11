extends "res://addons/maaacks_game_template/extras/scenes/WinScreen/WinScreen.gd"

func _ready():
	$Outro/AnimationPlayer.play("outro_win_animation")

func _on_outro_animation_finished():
	$Outro.queue_free()
