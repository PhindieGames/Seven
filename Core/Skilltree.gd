extends Control

onready var HIGHLIGHT_MATERIAL = preload("res://Games/Crafting/HighlightMaterial.tres")

var perfect_text = "You relax at your camp until night. Your acquired skills strengthen in your dreams.\n\nskill points: SKILL_POINTS"
var mistake_text = "You reflect on your day, and are more determined than ever to learn from your mistakes.\n\nskill points: SKILL_POINTS"


func _ready() -> void:
	$Name.text = ''
	$Description.text = ''
	var _e = GameManager.connect("power_updated", self, "on_power_updated")
	_e = GameManager.connect("timing_updated", self, "on_timing_updated")
	_e = GameManager.connect("precision_updated", self, "on_precision_updated")
	_e = GameManager.connect("skillpoints_updated", self, "on_skillpoints_updated")

func on_power_updated(power) -> void:
	$power_level.text = str(power)

func on_timing_updated(timing) -> void:
	$timing_level.text = str(timing)

func on_precision_updated(precision) -> void:
	$precision_level.text = str(precision)

func on_skillpoints_updated(skillpoints) -> void:
	if GameManager.mistake_in_the_day:
		$Day.text = mistake_text.replace('SKILL_POINTS', skillpoints)
	else:
		$Day.text = perfect_text.replace('SKILL_POINTS', skillpoints)

func show() -> void:
	set_process_input(true)
	self.visible = true
	$Name.text = ''
	$Description.text = ''


func hide() -> void:
	self.visible = false
	set_process_input(false)
	$timing.material = null
	$precision.material = null
	$power.material = null


func _input(event):
	if event is InputEventMouseButton and event.button_mask == 1:
		if $timing.material == HIGHLIGHT_MATERIAL:
			GameManager.increase_timing()
		if $precision.material == HIGHLIGHT_MATERIAL:
			GameManager.increase_precision()
		if $power.material == HIGHLIGHT_MATERIAL:
			GameManager.increase_power()

func _on_timing_mouse_entered() -> void:
	$timing.material = HIGHLIGHT_MATERIAL
	$Name.text = "Timing"
	$Description.text = "Increases the timing window in timing-based minigames."


func _on_timing_mouse_exited() -> void:
	$timing.material = null
	$Name.text = ""
	$Description.text = ""


func _on_precision_mouse_entered() -> void:
	$precision.material = HIGHLIGHT_MATERIAL
	$Name.text = "Precision"
	$Description.text = "Makes the targets larger in precision minigames."


func _on_precision_mouse_exited() -> void:
	$precision.material = null
	$Name.text = ""
	$Description.text = ""


func _on_power_mouse_entered() -> void:
	$power.material = HIGHLIGHT_MATERIAL
	$Name.text = "Strength"
	$Description.text = "A small chance to progress faster in mashing minigames."


func _on_power_mouse_exited() -> void:
	$power.material = null
	$Name.text = ""
	$Description.text = ""
