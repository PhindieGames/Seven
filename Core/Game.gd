extends Node2D
class_name Game

onready var applause = preload("res://assets/sfx/applause.wav")
onready var fail = preload("res://assets/sfx/seven_fail.wav")
# onready var applause = preload("res://assets/sfx/applause.wav")

onready var countdown = $CanvasLayer/Countdown
# onready var titlecard = $CanvasLayer/Titlecard
var minigame = null

signal game_lost
signal game_won

func _ready() -> void:
	var _e = countdown.connect("timeout", self, "minigame_timeout")
	$CanvasLayer/Skillscreen.hide()

func start_minigame(mini_game: Minigame, difficulty: int = 0) -> void:
	minigame = mini_game
	for child in get_children():
		if child is Minigame:
			child.queue_free()
	add_child(minigame)

	$CanvasLayer/Titlecard2/Preview.texture = minigame.show_preview()
	minigame.start(difficulty)
	minigame.set_process(false)
	$CanvasLayer/Titlecard2.visible = true
	$CanvasLayer/Titlecard2/Label.text = minigame.title
	$CanvasLayer/Titlecard2/Keys.visible = (minigame.controls == Minigame.CONTROLS.KEYS)
	$CanvasLayer/Titlecard2/Mouse.visible = (minigame.controls == Minigame.CONTROLS.MOUSE)
	$CanvasLayer/Titlecard2/Preview.visible = true

	yield(get_tree().create_timer(1), "timeout")
	$CanvasLayer/Titlecard2.visible = false
	$bgm.stream = minigame.bgm
	$bgm.play()

	countdown.start()
	# titlecard.play(minigame.name)
	var _e = minigame.connect("game_won", self, "minigame_won")
	_e = minigame.connect("game_lost", self, "minigame_lost")
	minigame.set_process(true)

func minigame_won() -> void:
	minigame.set_process(false)
	$bgm.stop()
	countdown.stop()
	$AudioStreamPlayer.stream = applause
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("game_won")

func minigame_lost() -> void:
	minigame.set_process(false)
	$bgm.stop()
	$AudioStreamPlayer.stream = fail
	$AudioStreamPlayer.play()
	countdown.stop()
	emit_signal("game_lost")

func minigame_timeout() -> void:
	minigame_lost()

func show_gameover_screen() -> void:
	$CanvasLayer/GameOver/gamecount.text = "After " + str(GameManager.current_level) + " games"
	$CanvasLayer/GameOver.visible = true

func show_skill_screen() -> void:
	$CanvasLayer/Skillscreen.show()

func hide_skill_screen() -> void:
	$CanvasLayer/Skillscreen.hide()


func _on_Button_pressed() -> void:
	GameManager.to_main_menu()
