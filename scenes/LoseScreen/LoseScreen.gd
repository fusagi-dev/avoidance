extends "res://addons/maaacks_game_template/extras/scenes/LoseScreen/LoseScreen.gd"

func _ready():
	$Outro/AnimationPlayer.play("outro_lose_animation")

func _on_outro_animation_finished():
	$Outro.queue_free()
