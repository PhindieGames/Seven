extends Control

onready var number_images = [
	preload("res://assets/zero.png"),
	preload("res://assets/one.png"),
	preload("res://assets/two.png"),
	preload("res://assets/three.png"),
	preload("res://assets/four.png"),
	preload("res://assets/five.png"),
	preload("res://assets/six.png"),
	preload("res://assets/seven.png")
]

onready var timer = $Timer
onready var label = $Label
onready var tween = $Tween
onready var sprite = $Sprite

var seconds_left: int = 0

signal timeout


func count_step() -> void:
	# Perform one animated countdown step
	animate_number(seconds_left)
	seconds_left -= 1


func _on_Timer_timeout() -> void:
	if seconds_left == 0:
		emit_signal("timeout")

	if seconds_left < 0:
		stop()
	else:
		count_step()


func animate_number(number: int) -> void:
	# label.text = str(number)
	# not currently centered, but probably will replace string with a Sprite anyway
	# (so centered scaling would be different)
	sprite.texture = number_images[number]
	tween.interpolate_property(
		sprite,
		"scale",
		Vector2(0.5, 0.5),
		Vector2(0.75, 0.75),
		1
	)
	tween.start()


func start(from: int = 7) -> void:
	timer.start()
	# label.visible = true
	seconds_left = from
	count_step()


func stop() -> void:
	timer.stop()
	label.visible = false
	sprite.texture = null
