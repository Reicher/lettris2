extends Node2D

# Define the Box scene to instantiate
var box_scene
var rng = RandomNumberGenerator.new()

func _ready():
	box_scene = load("res://box.tscn")

func _on_timer_timeout():
	# Get the viewport width and height
	var viewport_rect = get_viewport_rect()
	var viewport_width = viewport_rect.size.x

	# Generate random coordinates within the viewport width
	var random_pos = Vector2(rng.randf_range(0, viewport_width), -30)
	
	# Instantiate the Box scene at the random position
	var box = box_scene.instantiate()	
	box.position = random_pos
	
	# Add the instantiated scene to the current scene
	add_child(box)
	
	print("Creating box!")

