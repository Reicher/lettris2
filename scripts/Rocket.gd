extends Node2D

func _ready():
	# Connect the animation_finished signal of AnimationPlayer
	$AnimationPlayer.animation_finished.connect(_on_AnimationPlayer_animation_finished)
	# Connect the animation_finished signal of AnimatedSprite2D
	$AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)

func fire_to_the_left() -> void:
	$AnimationPlayer.play("fire_left")

func fire_to_the_right() -> void:
	$AnimationPlayer.play("fire_right")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fire_left" or anim_name == "fire_right":
		$AnimatedSprite2D.play("dead")

func _on_AnimatedSprite2D_animation_finished():
	if $AnimatedSprite2D.animation == "dead":
		# Hide the rocket sprite or remove it from the scene
		# Option 1: Hide the node
		$AnimatedSprite2D.hide()
		# Option 2: Remove the entire rocket node from the scene
		# self.queue_free()
