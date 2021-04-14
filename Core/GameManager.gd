extends Node

onready var GAME_FRAMEWORK = preload("res://Core/Game.tscn")

var game_framework: Game = null

var levels = [
	preload("res://Games/Crafting/Mine.tscn"),
	preload("res://Games/Crafting/SortRocks.tscn"),
	preload("res://Games/Crafting/Smelt.tscn"),
	preload("res://Games/Crafting/Pour.tscn"),
	preload("res://Games/Crafting/Shape.tscn"),
]

var current_level = -1

func start_game() -> void:
	var _e = get_tree().change_scene_to(GAME_FRAMEWORK)
	yield(get_tree().create_timer(0.05), "timeout")
	game_framework = get_tree().current_scene
	next_game()

func next_game() -> void:
	current_level += 1
	var level_select = current_level % len(levels)
	var difficulty = current_level / len(levels)
	var minigame: Minigame = levels[level_select].instance()
	game_framework.start_minigame(minigame, difficulty)
