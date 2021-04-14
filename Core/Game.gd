extends Node2D
class_name Game

onready var applause = preload("res://assets/sfx/applause.wav")
onready var fail = preload("res://assets/sfx/seven_fail.wav")
# onready var applause = preload("res://assets/sfx/applause.wav")

onready var countdown = $CanvasLayer/Countdown
onready var titlecard = $CanvasLayer/Titlecard
var minigame = null

func _ready() -> void:
	var _e = countdown.connect("timeout", self, "minigame_timeout")

func start_minigame(mini_game: Minigame, difficulty: int = 0) -> void:
	minigame = mini_game
	for child in get_children():
		if child is Minigame:
			child.queue_free()
	add_child(minigame)

	$CanvasLayer/Titlecard2.visible = true
	$CanvasLayer/Titlecard2/Label.text = minigame.name
	$CanvasLayer/Titlecard2/Keys.visible = (minigame.controls == Minigame.CONTROLS.KEYS)
	$CanvasLayer/Titlecard2/Mouse.visible = (minigame.controls == Minigame.CONTROLS.MOUSE)
	yield(get_tree().create_timer(1), "timeout")
	$CanvasLayer/Titlecard2.visible = false

	countdown.start()
	titlecard.play(minigame.name)
	var _e = minigame.connect("game_won", self, "minigame_won")
	_e = minigame.connect("game_lost", self, "minigame_lost")
	minigame.start(difficulty)

func minigame_won() -> void:
	minigame.set_process(false)
	countdown.stop()
	$AudioStreamPlayer.stream = applause
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(1), "timeout")
	GameManager.next_game()

func minigame_lost() -> void:
	$AudioStreamPlayer.stream = fail
	$AudioStreamPlayer.play()
	countdown.stop()
	# minigame.set_process(false)

func minigame_timeout() -> void:
	$AudioStreamPlayer.stream = fail
	$AudioStreamPlayer.play()
	countdown.stop()
	# minigame.set_process(false)
