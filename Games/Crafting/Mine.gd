extends Minigame

onready var tween: Tween = $Tween
onready var pickaxe: Sprite = $Pickaxe
onready var rock: Sprite = $Rock

const down_position = Vector2(444, 236)
const down_rotation = 0.0
const up_position = Vector2(582, 155)
const up_rotation = 39

var hits_per_stage: int = 2
var hits_done: int = 0
var is_swinging: bool = false

func _process(_delta: float) -> void:
	if not is_swinging:
		if is_up() and Input.is_action_just_pressed("ui_down"):
			pickaxe_down()
		elif is_down() and Input.is_action_just_pressed("ui_up"):
			pickaxe_up()

func is_up() -> bool:
	return pickaxe.global_position == up_position

func is_down() -> bool:
	return pickaxe.global_position == down_position

func start(difficulty: int = 0) -> void:
	hits_per_stage = hits_per_stage + difficulty

func tween_pickaxe_to(position: Vector2, rotation: float) -> void:
	var _e = tween.interpolate_property(
		pickaxe,
		"position",
		pickaxe.global_position,
		position,
		0.02
	)
	_e = tween.interpolate_property(
		pickaxe,
		"rotation_degrees",
		pickaxe.rotation_degrees,
		rotation,
		0.02
	)
	_e = tween.start()

func pickaxe_down() -> void:
	var target_position = Vector2(444, 236)
	var target_rotation = 0.0
	tween_pickaxe_to(target_position, target_rotation)

func pickaxe_up() -> void:
	var target_position = Vector2(582, 155)
	var target_rotation = 39
	tween_pickaxe_to(target_position, target_rotation)

func pickaxe_strikes_rock() -> void:
	hits_done += 1
	if hits_done % hits_per_stage == 0:
		rock.frame += 1
	# play sfx/particle
	if rock.frame == rock.hframes - 1:
		print("SEnding game_won")
		emit_signal("game_won")

func _on_Tween_tween_started(_object: Object, _key: NodePath) -> void:
	is_swinging = true

func _on_Tween_tween_all_completed() -> void:
	is_swinging = false
	if is_down():
		pickaxe_strikes_rock()
