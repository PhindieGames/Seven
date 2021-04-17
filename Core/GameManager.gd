extends Node

onready var GAME_FRAMEWORK = preload("res://Core/Game.tscn")

var game_framework: Game = null

var levels = [
#	preload("res://Games/Crafting/Mine.tscn"),
#	preload("res://Games/Crafting/SortRocks.tscn"),
#	preload("res://Games/Crafting/Smelt.tscn"),
#	preload("res://Games/Crafting/Pour.tscn"),
#	preload("res://Games/Crafting/Shape.tscn"),
#	preload("res://Games/Travel/Kindle.tscn"),
#	preload("res://Games/Travel/Pick.tscn"),
	preload("res://Games/Travel/Build.tscn"),
]

var current_level = -1
var lives_left = 4

signal life_updated(new_n_lives)

func _ready() -> void:
	emit_signal("life_updated", [lives_left])

func game_lost() -> void:
	lives_left -= 1
	emit_signal("life_updated", lives_left)
	if lives_left == 0:
		game_framework.show_gameover_screen()
	else:
		restart_game()


func start_game() -> void:
	var _e = get_tree().change_scene_to(GAME_FRAMEWORK)
	yield(get_tree().create_timer(0.05), "timeout")
	game_framework = get_tree().current_scene
	_e = game_framework.connect("game_lost", self, "game_lost")
	next_game()

func restart_game() -> void:
	var level_select = current_level % len(levels)
	var difficulty = current_level / len(levels)
	var minigame: Minigame = levels[level_select].instance()
	game_framework.start_minigame(minigame, difficulty)

func next_game() -> void:
	current_level += 1
	var level_select = current_level % len(levels)
	var difficulty = current_level / len(levels)
	var minigame: Minigame = levels[level_select].instance()
	game_framework.start_minigame(minigame, difficulty)
