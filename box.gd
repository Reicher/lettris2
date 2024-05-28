extends RigidBody2D

signal clicked(box)

var letterValues = {
	'A': 1, 'B': 3, 'C': 3, 'D': 2, 'E': 1, 'F': 4, 'G': 2, 'H': 4,
	'I': 1, 'J': 8, 'K': 5, 'L': 1, 'M': 3, 'N': 1, 'O': 1, 'P': 3,
	'Q': 10, 'R': 1, 'S': 1, 'T': 1, 'U': 1, 'V': 4, 'W': 4, 'X': 8,
	'Y': 4, 'Z': 10
}
var selected = false
var letter = " "
var value = 0

func _ready():
	letter = letterValues.keys()[randi() % letterValues.size()]
	value = letterValues[letter]
	
	$Letter.text = letter
	$Value.text = str(value)

func _on_texture_button_pressed():
	print("You clicked on box " + letter)
	select(not selected)
	clicked.emit(self)
	
func select(status):
	selected = status
	$Selected.visible  = selected

func destroy():
	print("Removing box " + letter)
	queue_free()
