extends Control

func _ready() -> void:
	$AnimatedSprite2D.play("default", randf_range(0.7, 2.0))
