extends Node

signal level_won
signal level_lost

func _on_lose_button_pressed():
	emit_signal("level_lost")

func _on_win_button_pressed():
	emit_signal("level_won")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_tile_map_void_prevailed():
	emit_signal("level_won")
