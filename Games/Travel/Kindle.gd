extends Minigame

var title = "Kindle"
var controls = CONTROLS.KEYS
onready var bgm = preload("res://assets/songs/marimba.wav")

onready var stick_rotation: Array = [
	preload("res://assets/Kindle/stick.png"),
	preload("res://assets/Kindle/stick_rotated.png")
]
var rotation_frame = 0

onready var smoke_animation: Array = [
	null,
	preload("res://assets/Kindle/smoke_0.png"),
	preload("res://assets/Kindle/smoke_1.png"),
	preload("res://assets/Kindle/smoke_2.png"),
]

onready var tween: Tween = $Tween
onready var left_arm: Sprite = $left_arm
onready var right_arm: Sprite = $right_arm
onready var stick: Sprite = $stick
onready var smoke: Sprite = $smoke

var strokes_per_stage = 5
var strokes = 0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		turn(246, 300)
	elif Input.is_action_just_pressed("ui_right"):
		turn(300, 246)

func start(difficulty: int = 0) -> void:
	strokes_per_stage = strokes_per_stage + difficulty * 2

func rotate_stick() -> void:
	rotation_frame = (rotation_frame + 1) % 2
	stick.texture = stick_rotation[rotation_frame]

func increase_strokes() -> void:
	strokes += 1
	if randf() > pow(0.8, GameManager.power):
		strokes += 1
	var smoke_frame = strokes / strokes_per_stage
	if strokes >= strokes_per_stage * len(smoke_animation):
		emit_signal("game_won")
	else:
		smoke.texture = smoke_animation[smoke_frame]

func turn(left_arm_y, right_arm_y) -> void:
	rotate_stick()
	increase_strokes()
	var _e = tween.interpolate_property(
		left_arm,
		"position",
		left_arm.position,
		Vector2(left_arm.position.x, left_arm_y),
		0.1
	)
	_e = tween.interpolate_property(
		right_arm,
		"position",
		right_arm.position,
		Vector2(right_arm.position.x, right_arm_y),
		0.1
	)
	_e = tween.start()
