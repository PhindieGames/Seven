extends Area2D

onready var sprite: Sprite = $flowers
onready var highlight_material = preload("res://Games/Crafting/HighlightMaterial.tres")

var collision_poly: CollisionPolygon2D = null
var id = 0

signal picked_up

func dimensions() -> Vector2:
	return sprite.get_rect().size

func get_collision_shape(id: int) -> CollisionPolygon2D:
	id = id - id % 2  # Maps odds to id - 1, because they share shapes.
	for child in get_children():
		if child.name.replace('Flower', '') == str(id):
			return child
	return null

func flowershape(id_: int = -1, exclude: int = -1) -> void:
	if id_ == -1:
		id_ = randi() % 12

	while id_ == exclude:
		id_ = randi() % 12
	id = id_

	var collider: CollisionPolygon2D = get_collision_shape(id)
	if collider != null:
		collision_poly = collider
		sprite.frame = id
		rotation_degrees = -30 + randf() * 60
		collider.set_disabled(false)
		collider.set_visible(true)


func _on_Flower_mouse_entered() -> void:
	sprite.material = highlight_material

func _on_Flower_mouse_exited() -> void:
	sprite.material = null

func _on_Flower_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		# 1 left, 2 right, 4 middle, 8 down, 16 up
		emit_signal("picked_up")
		queue_free()
