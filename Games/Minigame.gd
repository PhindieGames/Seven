extends Node2D
class_name Minigame

enum CONTROLS {
	KEYS,
	MOUSE
}

signal game_won  # warnings-disable
signal game_lost


func start(difficulty: int = 0) -> void:
	pass

func show_preview() -> Texture:
	return null
