extends Node2D
class_name Game


onready var countdown = $CanvasLayer/Countdown
onready var titlecard = $CanvasLayer/Titlecard
var minigame = null

func start_minigame(mini_game: Minigame, difficulty: int = 0) -> void:
	minigame = mini_game
	for child in get_children():
		if child is Minigame:
			child.queue_free()
	add_child(minigame)

	countdown.start()
	titlecard.play(minigame.name)
	var _e = minigame.connect("game_won", self, "minigame_won")
	_e = minigame.connect("game_lost", self, "minigame_lost")
	_e = countdown.connect("timeout", self, "minigame_timeout")
	minigame.start(difficulty)

func minigame_won() -> void:
	minigame.set_process(false)
	countdown.stop()
	GameManager.next_game()

func minigame_lost() -> void:
	print(":(:(")
	countdown.stop()

func minigame_timeout() -> void:
	print("zzz")
