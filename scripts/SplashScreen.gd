# SplashScreen.gd
extends Control

var main_menu = preload("res://scenes/MainMenu.tscn")

func _ready():
	$AnimationPlayer.play("fade_from_black")
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_from_black":
		$AnimationPlayer.play("fade_to_black")
	elif anim_name == "fade_to_black":
		get_tree().change_scene_to_packed(main_menu)
		
