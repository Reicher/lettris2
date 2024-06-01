extends TextureButton


func _on_pressed():	
	print("Start Game")
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
