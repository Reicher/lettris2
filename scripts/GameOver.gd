extends Control

var main_menu = preload("res://scenes/MainMenu.tscn")

func _ready() -> void:	
	var score_label = $"Outer Margin/Inner Margin/Most inner/TentBack/Score"
	score_label.text = str(Global.score)
	var tent = $"Outer Margin/Inner Margin/Most inner/TentBack/TentDoor"
	tent.play("open")

func _on_back_button_pressed():
	get_tree().change_scene_to_packed(main_menu)
