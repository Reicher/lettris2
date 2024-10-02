extends Control



func _ready() -> void:

	# Set up other UI elements like score
	var score_label = $"Outer Margin/Inner Margin/Most inner/TentBack/Score"
	score_label.text = str(Global.score)
	var tent = $"Outer Margin/Inner Margin/Most inner/TentBack/TentDoor"
	tent.play("open")
	tent.connect("animation_finished", _on_tent_door_finished)
	$"Left-Rocket".fire_to_the_left()
	$"Right-Rocket".fire_to_the_right()


# Callback for when the timer finishes
func _on_tent_door_finished() -> void:
	$"Outer Margin/BackButton".visible = true
	$"Outer Margin/Inner Margin/Most inner/HighScore".visible = true
	AudioManager.fanfare.play()


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
