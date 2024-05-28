extends RigidBody2D

signal clicked(box)

var selected = false
var letter = " "
var value = 0
var size = Vector2(80, 80) # Needs to be set dynamically later

func _ready():
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
