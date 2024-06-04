# SplashScreen.gd
extends Control

var main_menu = preload("res://scenes/MainMenu.tscn")

func _on_timer_timeout():
	get_tree().change_scene_to_packed(main_menu)
