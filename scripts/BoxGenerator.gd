extends Node2D

# Preload the box scenes
var Normal = preload("res://scenes/boxes/Basebox.tscn")
var Silver = preload("res://scenes/boxes/Silver.tscn")
var Gold = preload("res://scenes/boxes/Gold.tscn")
var Ball = preload("res://scenes/boxes/Ball.tscn")

var rng = RandomNumberGenerator.new()

var letterValues = {
	'A': 1, 'B': 3, 'C': 3, 'D': 2, 'E': 1, 'F': 4, 'G': 2, 'H': 4,
	'I': 1, 'J': 8, 'K': 5, 'L': 1, 'M': 3, 'N': 1, 'O': 1, 'P': 3,
	'Q': 10, 'R': 1, 'S': 1, 'T': 1, 'U': 1, 'V': 4, 'W': 4, 'X': 8,
	'Y': 4, 'Z': 10
}
var weightedList = [] # Used for deciding how often a letter should appear
	
func _ready():
	# Create a list where each letter appears a number of times equal to its weight
	for letter in letterValues:
		for i in int(10 / letterValues[letter]):
			weightedList.append(letter)
	
func _get_semi_random_letter():
	# Select a random element from the weighted list
	return weightedList[randi() % weightedList.size()]
	
func _get_next_box_type():
	var box_types = [Normal, Silver, Gold, Ball]	
	return box_types[randi() % box_types.size()]

# A new box should be created
func _on_timer_timeout():
		# Get the viewport width and height
	var viewport_rect = get_viewport_rect()
	var viewport_width = viewport_rect.size.x

	# Check if any box is above the visible screen
	for child in get_children():
		if child.name != "Timer" and child.position.y < 0:
			get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

	var box = _get_next_box_type().instantiate()	
	
	# Generate parameters for the box
	var x_bounds = Vector2(box.size[0]/2, viewport_width - box.size[0]/2)
	box.position = Vector2(rng.randf_range(x_bounds[0], x_bounds[1]), -30)
	box.letter = _get_semi_random_letter()
	box.value = letterValues[box.letter]
	
	# Ensure the UI node is correctly referenced
	var ui_node = get_node("../Panel/UI")

	# Connect signals
	box.clicked.connect(ui_node.box_clicked)

	# Add the instantiated scene to the current scene
	add_child(box)
