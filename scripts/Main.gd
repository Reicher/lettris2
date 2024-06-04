extends Node2D

var splash = preload("res://scenes/SplashScreen.tscn")

func _ready():
	get_tree().change_scene_to_packed(splash)
