extends Node2D

# Define the Box scene to instantiate
var box_scene
var rng = RandomNumberGenerator.new()

var letterValues = {
	'A': 1, 'B': 3, 'C': 3, 'D': 2, 'E': 1, 'F': 4, 'G': 2, 'H': 4,
	'I': 1, 'J': 8, 'K': 5, 'L': 1, 'M': 3, 'N': 1, 'O': 1, 'P': 3,
	'Q': 10, 'R': 1, 'S': 1, 'T': 1, 'U': 1, 'V': 4, 'W': 4, 'X': 8,
	'Y': 4, 'Z': 10
}

func _ready():
	box_scene = load("res://box.tscn")

# A new box should be created
func _on_timer_timeout():
		# Get the viewport width and height
	var viewport_rect = get_viewport_rect()
	var viewport_width = viewport_rect.size.x

	# Check if any box is above the visible screen
	for child in get_children():
		if child.name != "Timer" and child.position.y < 0:
			print("Game over")

	# Instantiate the Box scene at the random position
	var box = box_scene.instantiate()	
	
	# Generate parameters for the box
	var x_bounds = Vector2(box.size[0]/2, viewport_width - box.size[0]/2)
	box.position = Vector2(rng.randf_range(x_bounds[0], x_bounds[1]), -30)
	box.letter = letterValues.keys()[randi() % letterValues.size()]
	box.value = letterValues[box.letter]
	
	# Ensure the UI node is correctly referenced
	var ui_node = get_node("../Panel/UI")

	# Connect signals
	box.clicked.connect(ui_node.box_clicked)

	# Add the instantiated scene to the current scene
	add_child(box)
