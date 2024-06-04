extends TextureButton

var game = preload("res://scenes/Game.tscn")

func _on_pressed():	
	print("Start Game")
	get_tree().change_scene_to_packed(game)
