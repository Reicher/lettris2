extends Control

var game = preload("res://scenes/Game.tscn")

func _on_play_button_pressed():
	print("Start Game")
	get_tree().change_scene_to_packed(game)
