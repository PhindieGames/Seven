extends Control

onready var hearts = $Hearts

func _ready() -> void:
	GameManager.connect("life_updated", self, "set_lives")

func set_lives(n: int) -> void:
	hearts.rect_size = Vector2(n * 100, hearts.rect_size.y)
	hearts.rect_position = Vector2(1020 - (n * 50), hearts.rect_position.y)
