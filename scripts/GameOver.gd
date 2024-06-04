extends Control

var main_menu = preload("res://scenes/MainMenu.tscn")

func _on_texture_button_pressed():
	get_tree().change_scene_to_packed(main_menu)
