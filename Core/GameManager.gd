extends Node

onready var GAME_FRAMEWORK = preload("res://Core/Game.tscn")
onready var MAIN_MENU = preload("res://Core/MainMenu.tscn")

var game_framework: Game = null

var timing = 0
var power = 0
var precision = 0
var skillpoints = 0
var mistake_in_the_day = false

var levels = [
#	preload("res://Games/Crafting/Mine.tscn"),
#	preload("res://Games/Crafting/SortRocks.tscn"),
#	preload("res://Games/Crafting/Smelt.tscn"),
	preload("res://Games/Crafting/Pour.tscn"),
#	preload("res://Games/Crafting/Shape.tscn"),
#	preload("res://Games/Travel/Kindle.tscn"),
#	preload("res://Games/Travel/Pick.tscn"),
#	preload("res://Games/Travel/Build.tscn"),
]

var current_level = -1
var lives_left = 4

signal life_updated(new_value)
signal power_updated(new_value)
signal precision_updated(new_value)
signal timing_updated(new_value)
signal skillpoints_updated(new_value)

func _ready() -> void:
	randomize()
	emit_signal("life_updated", [lives_left])
	var _e = self.connect("skillpoints_updated", self, "hide_and_continue_skillscreen_at_zero")

func hide_and_continue_skillscreen_at_zero(__) -> void:
	if skillpoints == 0:
		game_framework.hide_skill_screen()
		next_game()

func game_lost() -> void:
	lives_left -= 1
	mistake_in_the_day = true
	emit_signal("life_updated", lives_left)
	if lives_left == 0:
		game_framework.show_gameover_screen()
	else:
		restart_game()

func to_main_menu() -> void:
	var _e = get_tree().change_scene_to(MAIN_MENU)
	yield(get_tree().create_timer(0.05), "timeout")
	timing = 0
	power = 0
	precision = 0
	skillpoints = 0
	mistake_in_the_day = false
	current_level = -1
	lives_left = 4

func get_life() -> void:
	lives_left += 1
	emit_signal("life_updated", lives_left)

func increase_power():
	if skillpoints > 0:
		skillpoints -= 1
		power += 1
		emit_signal("skillpoints_updated", skillpoints)
		emit_signal("power_updated", power)

func increase_precision():
	if skillpoints > 0:
		skillpoints -= 1
		precision += 1
		emit_signal("skillpoints_updated", skillpoints)
		emit_signal("precision_updated", precision)

func increase_timing():
	if skillpoints > 0:
		skillpoints -= 1
		timing += 1
		emit_signal("skillpoints_updated", skillpoints)
		emit_signal("timing_updated", timing)


func progress_adventure() -> void:
	if current_level != -1 and (current_level + 1) % len(levels) == 0:
		skillpoints += 1
		if mistake_in_the_day:
			skillpoints += 1
		emit_signal("skillpoints_updated", skillpoints)
		get_life()
		game_framework.show_skill_screen()
		mistake_in_the_day = false
	else:
		next_game()

func start_game() -> void:
	var _e = get_tree().change_scene_to(GAME_FRAMEWORK)
	yield(get_tree().create_timer(0.05), "timeout")
	game_framework = get_tree().current_scene
	_e = game_framework.connect("game_lost", self, "game_lost")
	_e = game_framework.connect("game_won", self, "progress_adventure")
	progress_adventure()

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


func random_game() -> void:
	current_level += 1
	var level_select = randi() % len(levels)
	var difficulty = current_level / 5
	var minigame: Minigame = levels[level_select].instance()
	game_framework.start_minigame(minigame, difficulty)


func start_arcade() -> void:
	current_level = 0
	timing = 0
	power = 0
	precision = 0
	skillpoints = 0
	var _e = get_tree().change_scene_to(GAME_FRAMEWORK)
	yield(get_tree().create_timer(0.05), "timeout")
	game_framework = get_tree().current_scene
	_e = game_framework.connect("game_lost", self, "game_lost")
	_e = game_framework.connect("game_won", self, "random_game")
	random_game()
