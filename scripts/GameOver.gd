extends Control

var main_menu = preload("res://scenes/MainMenu.tscn")
var score = 0

func high_score_worthy():
	return score > 10

func _ready() -> void:
	var tent = $"Outer Margin/Inner Margin/Most inner/TentBack/AnimatedSprite2D"
	tent.play("open")
	
	if high_score_worthy():
		$"Outer Margin/TextureButton/Label".text = "Submit"
		$"Outer Margin/Inner Margin/Most inner/NameSelect".show()
	

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
