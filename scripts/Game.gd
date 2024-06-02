extends Control

# Preload the box scenes
var Normal = preload("res://scenes/boxes/Basebox.tscn")
var Silver = preload("res://scenes/boxes/Silver.tscn")
var Gold = preload("res://scenes/boxes/Gold.tscn")
var Ball = preload("res://scenes/boxes/Ball.tscn")

var rng = RandomNumberGenerator.new()

var letterData = {
	'A': { 'value': 1, 'quantity': 9 },  'B': { 'value': 3, 'quantity': 2 },
	'C': { 'value': 3, 'quantity': 2 },  'D': { 'value': 2, 'quantity': 4 },
	'E': { 'value': 1, 'quantity': 12 }, 'F': { 'value': 4, 'quantity': 2 },
	'G': { 'value': 2, 'quantity': 3 },  'H': { 'value': 4, 'quantity': 2 },
	'I': { 'value': 1, 'quantity': 9 },  'J': { 'value': 8, 'quantity': 1 },
	'K': { 'value': 5, 'quantity': 1 },  'L': { 'value': 1, 'quantity': 4 },
	'M': { 'value': 3, 'quantity': 2 },  'N': { 'value': 1, 'quantity': 6 },
	'O': { 'value': 1, 'quantity': 8 },  'P': { 'value': 3, 'quantity': 2 },
	'Q': { 'value': 10, 'quantity': 1 }, 'R': { 'value': 1, 'quantity': 6 },
	'S': { 'value': 1, 'quantity': 4 },  'T': { 'value': 1, 'quantity': 6 },
	'U': { 'value': 1, 'quantity': 4 },  'V': { 'value': 4, 'quantity': 2 },
	'W': { 'value': 4, 'quantity': 2 },  'X': { 'value': 8, 'quantity': 1 },
	'Y': { 'value': 4, 'quantity': 2 },  'Z': { 'value': 10, 'quantity': 1 }
}

func _ready():
	pass
	
func _get_semi_random_letter():
	var random_number = randi() % (98 - 1) # Number of letter tiles
	var count = 0
	
	# Find the letter corresponding to the random_number
	for letter in letterData.keys():
		count += letterData[letter]['quantity']
		if count > random_number:
			return letter
	
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
	box.value = letterData[box.letter].value
	
	# Connect box click to UI
	var ui_node = get_node("Panel/UI")
	box.clicked.connect(ui_node.box_clicked)

	# Add the instantiated scene to the current scene
	add_child(box)
