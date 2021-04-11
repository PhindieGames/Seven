extends Control

onready var timer = $Timer
onready var label = $Label
onready var tween = $Tween

var seconds_left: int = 0

signal timeout


func count_step() -> void:
	# Perform one animated countdown step
	animate_number(seconds_left)
	seconds_left -= 1


func _on_Timer_timeout() -> void:
	if seconds_left == 0:
		stop()
		emit_signal("timeout")
	else:
		count_step()


func animate_number(number: int) -> void:
	label.text = str(number)
	# not currently centered, but probably will replace string with a Sprite anyway
	# (so centered scaling would be different)
	tween.interpolate_property(
		label,
		"rect_scale",
		Vector2(1, 1),
		Vector2(2, 2),
		1
	)
	tween.start()


func start(from: int = 7) -> void:
	timer.start()
	seconds_left = from
	count_step()


func stop() -> void:
	timer.stop()
	label.visible = false
