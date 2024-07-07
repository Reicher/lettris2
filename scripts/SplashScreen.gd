# SplashScreen.gd
extends Control

var main_menu = preload("res://scenes/MainMenu.tscn")

func _ready():
	$AnimationPlayer.play("fade_from_black")
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)
	if Global.sfx_on: # TODO: This is before the main menu mutes this bus, maybe should be done inside global? 
		AudioManager.splash_sfx.play()

func _on_animation_finished(anim_name):
	if anim_name == "fade_from_black":
		$AnimationPlayer.play("fade_to_black")
	elif anim_name == "fade_to_black":
		_change_scene()
		
func _change_scene():
	get_tree().change_scene_to_packed(main_menu)
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		_change_scene()
