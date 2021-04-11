extends Control

export(String) var text = ''

onready var animation_player = $AnimationPlayer

func play(name: String) -> void:
	$Label.text = name
	animation_player.play("BounceOut")
