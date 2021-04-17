extends Minigame

var controls = CONTROLS.MOUSE

onready var FLOWER = preload("res://Games/Travel/Flower.tscn")

var placed_flowers: Array = []  # Array of Rects for computing valid placements
var flower_to_click = null

func start(difficulty: int = 0) -> void:
	spawn_flowers(15 +  3 * difficulty)

func show_preview() -> Texture:
	flower_to_click = add_flower_to_scene()
	return load("res://assets/Pick/flower"+ str(flower_to_click.id) + ".png") as Texture

func spawn_flowers(n: int) -> void:
	for __ in range(n - 1):
		var _f = add_flower_to_scene()

func add_flower_to_scene() -> Node:
	var flower = FLOWER.instance()
	add_child(flower)
	if flower_to_click != null:
		flower.flowershape(-1, flower_to_click.id)
	else:
		flower.flowershape()

	var x = 50 + randf() * (get_viewport().size.x - 100)
	var y = 50 + randf() * (get_viewport().size.y - 100)
	flower.global_position = Vector2(x, y)
	flower.connect("picked_up", self, "on_pick_up", [flower])
	return flower

func on_pick_up(flower: Area2D) -> void:
	if flower == flower_to_click:
		emit_signal("game_won")
