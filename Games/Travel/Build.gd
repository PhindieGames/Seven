extends Minigame

onready var HIGHLIGHT_MATERIAL = preload("res://Games/Crafting/HighlightMaterial.tres")

var title = "Build"
var controls = CONTROLS.KEYS
onready var bgm = preload("res://assets/songs/fun.wav")

var current_key = null
onready var key_to_sprite = {
	"up": $up_key,
	"right": $right_key,
	"left": $left_key,
	"down": $down_key
}

var keys_to_press = []
var strokes_per_frame = 0

func _process(_delta: float) -> void:
	for direction in key_to_sprite.keys():
		if Input.is_action_just_pressed("ui_"+direction):
			key_pressed(direction)

func start(difficulty: int = 0) -> void:
	var min_skill = min(GameManager.power, min(GameManager.timing, GameManager.precision))
	var n = 6 + difficulty * 2 - min_skill
	strokes_per_frame = n / 3
	var keys = key_to_sprite.keys()
	for __ in range(n):
		var key_index = randi() % len(keys)
		if keys_to_press != [] and keys[key_index] == keys_to_press[-1]:
			key_index = (key_index + 1) % len(keys)
		keys_to_press.append(keys[key_index])
	next_key()

func key_pressed(name: String) -> void:
	if name == current_key:
		next_key()

func next_key() -> void:
	if current_key != null:
		key_to_sprite[current_key].material = HIGHLIGHT_MATERIAL
		yield(get_tree().create_timer(0.05), "timeout")
		key_to_sprite[current_key].material = null
		key_to_sprite[current_key].visible = false
	current_key = keys_to_press.pop_front()
	if len(keys_to_press) == 4:
		$camp1.visible = true
	if len(keys_to_press) == 2:
		$camp2.visible = true
	if current_key == null:
		$camp3.visible = true
		emit_signal("game_won")
	else:
		key_to_sprite[current_key].visible = true
