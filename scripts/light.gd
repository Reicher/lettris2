extends Control

var active = bool(randi() % 2)

func _ready() -> void:
	$AnimatedSprite2D.frame = 0 if active else 2
	$Timer.wait_time = randf_range(0.3, 1)
	$Timer.start()

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.play("off" if active else "on")
	$AnimatedSprite2D.connect("animation_finished", finish_toggle)
	
func finish_toggle() -> void: 
	active = !active
