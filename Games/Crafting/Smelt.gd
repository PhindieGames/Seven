extends Minigame

var title = "Smelt"
var controls = CONTROLS.KEYS
onready var bgm = preload("res://assets/songs/funky.wav")

onready var ORE = preload("res://Games/Crafting/RockPiece.tscn")
onready var ORE_HIGHLIGHT = preload("res://Games/Crafting/HighlightMaterial.tres")

onready var ore_spawn = $OreSpawn
onready var ore_stop = $OreStop
onready var furnace_target = $FurnaceEntry
onready var throw_window = $ThrowWindow
onready var timer = $Timer

var sliding_ores = []
var base_ore_speed := 500.0  # pixels per second, screen width is about 1020
var amount_to_melt := 4

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		throw_ore()

func throw_ore() -> void:
	var ore_tween = sliding_ores.pop_front()
	if ore_tween != null:
		var ore = ore_tween[0]
		var left_right_tween = ore_tween[1]
		left_right_tween.stop(ore)
		left_right_tween.queue_free()

		var target = Vector2(ore.global_position.x, ore.global_position.y - 500)
		if throw_window.overlaps_area(ore):
			target = furnace_target.global_position

		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(
			ore,
			"global_position",
			ore.global_position,
			target,
			0.2
		)
		tween.start()
		if target == furnace_target.global_position:
			tween.connect("tween_all_completed", self, "ore_in_furnace", [ore, tween])

func ore_in_furnace(ore: Area2D, tween: Tween) -> void:
	ore.queue_free()
	tween.queue_free()

	amount_to_melt -= 1
	if amount_to_melt == 0:
		emit_signal("game_won")
		timer.stop()

func start(difficulty: int = 0) -> void:
	amount_to_melt += difficulty
	base_ore_speed = base_ore_speed * (10 + difficulty) / 10
	var scale = 1 + (1 - pow(0.8, GameManager.timing))
	$ThrowWindow.scale = Vector2(scale, scale)
	timer.connect("timeout", self, "spawn_ore")
	timer.wait_time = 4.0 / float(amount_to_melt)
	yield(get_tree().create_timer(0.5), "timeout")
	timer.start()

func spawn_ore() -> void:
	var ore: Area2D = ORE.instance()
	var tween: Tween = Tween.new()
	add_child(ore)
	add_child(tween)
	ore.is_iron = true
	ore.rockshape()
	ore.global_position = ore_spawn.global_position
	var _v = tween.interpolate_property(
		ore,
		"global_position",
		ore_spawn.global_position,
		ore_stop.global_position,
		1.0  # seconds
	)
	var _e = tween.start()
	_e = tween.connect("tween_all_completed", self, "left_right_tween_completed", [ore, tween])
	sliding_ores.append([ore, tween])

func left_right_tween_completed(_ore, tween) -> void:
	sliding_ores.pop_front()
	tween.queue_free()
