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

	# Instantiate the Box scene at the random position
	var box = box_scene.instantiate()	
	
	# Generate random coordinates within the viewport width
	box.position = Vector2(rng.randf_range(0, viewport_width), -30)
	
	# Ensure the UI node is correctly referenced
	var ui_node = get_node("../Panel/UI")
	if ui_node == null:
		print("UI node not found!")
		return
	
	# Connect signals
	box.clicked.connect(ui_node.box_clicked)

	# Add the instantiated scene to the current scene
	add_child(box)
