extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("default", randf_range(0.7, 2.0))
