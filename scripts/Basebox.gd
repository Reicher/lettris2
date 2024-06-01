extends RigidBody2D

signal clicked(box)

@export var multiplier = 1

var selected = false
var letter = " "
var value = 0
var size = Vector2(80, 80) # TODO: Needs to be set dynamically

func _ready():
	$Letter.text = letter
	value *= multiplier
	print("Value for " + letter + " is " + str(value) + " (multi x" + str(multiplier) + ")")
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
