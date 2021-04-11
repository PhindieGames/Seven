extends Node2D


onready var minigame: Minigame = $Node2D
onready var countdown = $CanvasLayer/Countdown
onready var titlecard = $CanvasLayer/Titlecard

func _ready() -> void:
	start_minigame(minigame)

func start_minigame(minigame: Minigame) -> void:
	countdown.start()
	titlecard.play(minigame.name)
	minigame.connect("game_won", self, "minigame_won")
	minigame.connect("game_lost", self, "minigame_lost")
	countdown.connect("timeout", self, "minigame_timeout")
	minigame.start(0)

func minigame_won() -> void:
	minigame.set_process(false)
	print("Hoorah!")
	countdown.stop()

func minigame_lost() -> void:
	print(":(:(")
	countdown.stop()

func minigame_timeout() -> void:
	print("zzz")
