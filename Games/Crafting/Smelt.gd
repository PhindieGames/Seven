extends Minigame

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

func _process(delta: float) -> void:
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
			amount_to_melt -= 1
			if amount_to_melt == 0:
				emit_signal("game_won")
				timer.stop()

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
			tween.connect("tween_all_completed", self, "free_ore", [ore, tween])

func free_ore(ore: Area2D, tween: Tween) -> void:
	ore.queue_free()
	tween.queue_free()

func start(difficulty: int) -> void:
	amount_to_melt += difficulty
	base_ore_speed = base_ore_speed * (10 + difficulty) / 10
	timer.connect("timeout", self, "spawn_ore")
	timer.wait_time = 4.0 / float(amount_to_melt)
	timer.start()

func spawn_ore() -> void:
	var ore: Area2D = ORE.instance()
	var tween: Tween = Tween.new()
	add_child(ore)
	add_child(tween)
	ore.is_iron = true
	ore.rockshape()
	ore.global_position = ore_spawn.global_position
	tween.interpolate_property(
		ore,
		"global_position",
		ore_spawn.global_position,
		ore_stop.global_position,
		1.0  # seconds
	)
	tween.start()
	tween.connect("tween_all_completed", self, "left_right_tween_completed", [ore, tween])
	sliding_ores.append([ore, tween])

func left_right_tween_completed(ore, tween) -> void:
	sliding_ores.pop_front()
	tween.queue_free()
