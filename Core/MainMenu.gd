extends Control

onready var main = $Main
onready var about = $About


func _on_Back_pressed() -> void:
	main.set_visible(true)
	about.set_visible(false)


func _on_About_pressed() -> void:
	main.set_visible(false)
	about.set_visible(true)


func _on_Play_pressed() -> void:
	GameManager.start_game()


func _on_Arcade_pressed() -> void:
	GameManager.start_arcade()
