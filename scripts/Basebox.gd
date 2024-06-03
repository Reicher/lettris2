extends RigidBody2D

signal clicked(box)

@export var multiplier = 1

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

var selected = false
var letter = " "
var value = 0
var size = Vector2(80, 80) # TODO: Needs to be set dynamically

func _get_semi_random_letter():
	var random_number = randi() % (98 - 1) # Number of letter tiles
	var count = 0
	
	# Find the letter corresponding to the random_number
	for letter in letterData.keys():
		count += letterData[letter]['quantity']
		if count > random_number:
			return letter

func _ready():
	letter = _get_semi_random_letter()
	value = letterData[letter].value
	value *= multiplier
	$Letter.text = letter		
	$Value.text = str(value)

func _on_texture_button_pressed():
	select(not selected)
	clicked.emit(self)
	
func select(status):
	selected = status
	$Selected.visible  = selected

func destroy():
	queue_free()
