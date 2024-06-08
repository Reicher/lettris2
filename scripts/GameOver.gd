extends Control

var main_menu = preload("res://scenes/MainMenu.tscn")

func _ready() -> void:
	var tent = $"Outer Margin/Inner Margin/Most inner/VBoxContainer/TentBack/AnimatedSprite2D"
	tent.play("open")

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
