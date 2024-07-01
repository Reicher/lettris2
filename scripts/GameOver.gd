extends Control

var main_menu = preload("res://scenes/MainMenu.tscn")
var submit_highscore = false

func high_score_worthy():
	return Global.score > 10

func _ready() -> void:	
	var score_label = $"Outer Margin/Inner Margin/Most inner/TentBack/Label"
	score_label.text = str(Global.score)
	var tent = $"Outer Margin/Inner Margin/Most inner/TentBack/AnimatedSprite2D"
	tent.play("open")
	
	if high_score_worthy():
		$"Outer Margin/TextureButton/Label".text = "Submit"
		$"Outer Margin/Inner Margin/Most inner/NameSelect".show()
	else: 
		_show_highscore_table()

func _show_highscore_table() -> void:
	$"Outer Margin/TextureöButton/Label".text = "Main Menu"

func _on_texture_button_pressed() -> void:
	if submit_highscore:
		_show_highscore_table()
		pass
	else:
		get_tree().change_scene_to_packed(main_menu)
