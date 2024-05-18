extends "res://addons/maaacks_game_template/extras/scenes/WinScreen/WinScreen.gd"

func _ready():
	$Outro/AnimationPlayer.play("outro_win_animation")
	await($Outro.animation_finished)
	$Outro.queue_free()
	$ConfirmMainMenu/AudioStreamPlayer.play()
