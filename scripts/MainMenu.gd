extends Control

var game = preload("res://scenes/Game.tscn")

var tips = ["The red button in the lower left corner clears current word.",
		"Gold boxes are worth three times normal!",
		"Silver boxes are worth twice as much as regular boxes!",
		"Multiboxes multiplies the whole word two or three times!!",
		"Bomb boxes are always worth 0 points.",
		"The frequency of box drops is logarithmic",
		"Bombs destroys the closest boxes without granting you any points.",
		"You can use several multi boxes at a time!",
		"Hi mom!",
		"Big boxes, balls and suitcases works like the common boxes", 
		"Lettris 1.0 was coded mostly on a train", 
		"Lettris 2.0 was coded mostly with a baby straped to the chest"]

func _ready() -> void:
	$VBoxContainer/random_tip.text = tips.pick_random()

func _on_play_button_pressed():
	print("Start Game")
	get_tree().change_scene_to_packed(game)
