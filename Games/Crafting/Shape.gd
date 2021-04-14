extends Minigame

onready var animator: AnimationPlayer = $AnimationPlayer
onready var vertical_tween: Tween = $UpDownTween
onready var horizontal_tween: Tween = $LeftRightTween
onready var hammer: Sprite = $hammer
onready var sword: Sprite = $Sword

var hits_per_stage = 2
var hits = 0
var hammer_direction = 0

func _ready() -> void:
	var _e = horizontal_tween.connect("tween_all_completed", self, "move_hammer_to_other_side")
	move_hammer_left_to_right()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_down") and not vertical_tween.is_active():
		hit()

func move_hammer_left_to_right() -> void:
	$LeftRightTween.interpolate_property(
		hammer,
		"global_position",
		Vector2(340, hammer.global_position.y),
		Vector2(680, hammer.global_position.y),
		1.0
	)
	$LeftRightTween.start()
	hammer_direction = 1

func move_hammer_right_to_left() -> void:
	$LeftRightTween.interpolate_property(
		hammer,
		"global_position",
		Vector2(680, hammer.global_position.y),
		Vector2(340, hammer.global_position.y),
		1.0
	)
	$LeftRightTween.start()
	hammer_direction = -1

func move_hammer_to_other_side() -> void:
	if hammer.global_position.x == 340:
		move_hammer_left_to_right()
	else:
		move_hammer_right_to_left()

func hit():
	var _e = horizontal_tween.stop_all()
	var playback_speed = 2.0
	_e = vertical_tween.interpolate_property(
		hammer,
		"global_position",
		Vector2(hammer.global_position.x, 360),
		Vector2(hammer.global_position.x, 400),
		0.4 / playback_speed
	)
	_e = vertical_tween.start()
	animator.play("strike", -1, playback_speed)
	yield(animator, "animation_finished")

	_e = vertical_tween.interpolate_property(
		hammer,
		"global_position",
		Vector2(hammer.global_position.x, 400),
		Vector2(hammer.global_position.x, 360),
		0.4 / playback_speed
	)
	_e = vertical_tween.start()
	animator.play("strike", -1, -playback_speed, true)
	yield(animator, "animation_finished")
	_e = horizontal_tween.resume_all()

func move_hit_area() -> void:
	var current_x = $HitArea.global_position.x
	var distance = 40 + randf() * 240

	var target_x = current_x + distance * hammer_direction
	var turn_around_corner_bonus = 30  # make it a bit easier
	if target_x > 680:
		target_x = 680 - (target_x + turn_around_corner_bonus - 680)
	elif target_x < 350:
		target_x = 350 + (350 - target_x) + turn_around_corner_bonus

	$HitArea.global_position = Vector2(target_x, $HitArea.global_position.y)


func _on_HitArea_area_entered(_area: Area2D) -> void:
	hits += 1
	if hits % hits_per_stage == 0:
		sword.frame += 1
	if sword.frame == 3:
		emit_signal("game_won")
	move_hit_area()
