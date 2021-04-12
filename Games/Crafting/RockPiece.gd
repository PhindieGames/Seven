extends Area2D

onready var sprite: Sprite = $Sprite
onready var highlight_material = preload("res://Games/Crafting/HighlightMaterial.tres")

var rock_piece_id: int = 0
var is_iron: bool = false
var collision_poly: CollisionPolygon2D = null

signal picked_up

func get_collision_shape(id: int) -> CollisionPolygon2D:
	for child in get_children():
		if child.name.replace('Rock', '') == str(id):
			return child
	return null

func get_random_id() -> int:
	if is_iron:
		return randi() % 5
	else:
		return 5 + randi() % 1

func rockshape(id: int = -1) -> void:
	if id == -1:
		id = get_random_id()

	var collider: CollisionPolygon2D = get_collision_shape(id)
	if collider != null:
		collision_poly = collider
		rock_piece_id = id
		sprite.frame = id
		# rotation_degrees = randf() * 360
		collider.set_disabled(false)
		collider.set_visible(true)

func _on_RockPiece_mouse_entered() -> void:
	sprite.material = highlight_material

func _on_RockPiece_mouse_exited() -> void:
	sprite.material = null

func _on_RockPiece_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print(event.button_mask)
		# 1 left, 2 right, 4 middle, 8 down, 16 up
		emit_signal("picked_up")
		queue_free()
