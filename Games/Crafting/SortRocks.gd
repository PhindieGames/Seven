extends Minigame

var controls = CONTROLS.MOUSE

onready var ROCKPIECE = preload("res://Games/Crafting/RockPiece.tscn")
onready var bgm = preload("res://assets/songs/steelguitar.wav")

var rocks_amount: int = 6
var iron_amount: int = 4
var placed_rocks: Array = []  # Array of Rects for computing valid placements

func show_preview() -> Texture:
	return load("res://assets/iron.png") as Texture

func start(difficulty: int = 0) -> void:
	rocks_amount += difficulty
	iron_amount += difficulty
	spawn_rocks()

func spawn_rocks() -> void:
	for __ in range(iron_amount):
		var piece = ROCKPIECE.instance()
		add_child(piece)
		piece.is_iron = true
		piece.rockshape(-1)
		if not add_rock_to_screen(piece):
			remove_child(piece)
			print("Failed to place iron.")
		else:
			var scale = 1 + (1 - pow(0.8, GameManager.precision))
			piece.scale = Vector2(scale, scale)
			piece.connect("picked_up", self, "on_pick_up", [piece])
	for __ in range(rocks_amount):
		var piece = ROCKPIECE.instance()
		add_child(piece)
		piece.is_iron = false
		piece.rockshape(-1)
		if not add_rock_to_screen(piece):
			remove_child(piece)
			print("Failed to place rock.")
		else:
			piece.connect("picked_up", self, "on_pick_up", [piece])

func add_rock_to_screen(rock: Area2D) -> bool:
	# todo: make placement smarter
	for _i in range(100):
		var is_placed = true
		var x = 50 + randf() * (get_viewport().size.x - 100)
		var y = 50 + randf() * (get_viewport().size.y - 100)
		rock.global_position = Vector2(x, y)
		var new_rock_rect := Rect2(rock.global_position, rock.dimensions())
		for rock_rect in placed_rocks:
			if new_rock_rect.intersects(rock_rect):
					is_placed = false
					break
		if is_placed:
			placed_rocks.append(new_rock_rect)
			return true
	return false


func on_pick_up(rock: Area2D) -> void:
	if rock.is_iron:
		iron_amount -= 1
		if iron_amount == 0:
			emit_signal("game_won")
	else:
		emit_signal("game_lost")
