extends "res://addons/maaacks_game_template/extras/scenes/LoseScreen/LoseScreen.gd"

func _ready():
	$Outro/AnimationPlayer.play("outro_lose_animation")
	await($Outro.animation_finished)
	$Outro.queue_free()
