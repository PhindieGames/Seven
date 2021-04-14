extends Minigame

var controls = CONTROLS.KEYS

onready var pot: Sprite = $pot
onready var indicator: Sprite = $indicator

var change_rate = 0
var total_poured = 0
var amount_to_pour = 1000.0
var pour_per_stage = 250.0

func pour_rate(position: int, relative: bool = true) -> int:
	if not relative:
		position -= 180

	if position < 60:
		return 0
	if position < 120:
		return 1
	if position < 140:
		return 2
	if position < 180:
		return 3
	return 4


func start(difficulty: int = 0) -> void:
	amount_to_pour = 500 + 250 * difficulty
	pour_per_stage = amount_to_pour / 4

func _process(delta: float) -> void:
	pour_process()

	if Input.is_action_pressed("ui_right"):
		change_rate += 20 * delta
	elif Input.is_action_pressed("ui_left"):
		change_rate -= 20 * delta
	elif abs(change_rate) < 10:
		change_rate *= (1 + (1 * delta))
	else:
		change_rate *= (1 + (0.1 * delta))

	indicator.global_position.x = clamp(indicator.global_position.x + change_rate, 180, 380)
	if indicator.global_position.x == 180:
		change_rate = 0

func pour_process() -> void:
	var rate = pour_rate(int(indicator.global_position.x), false)
	pot.frame = rate
	if rate == 4:
		emit_signal("game_lost")
	total_poured += max(rate - 1, 0) * 3
	$pour.frame = min(round(total_poured / pour_per_stage), 4)
	if total_poured > amount_to_pour:
		emit_signal("game_won")
