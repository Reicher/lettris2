extends TextureRect

var word
var boxes

func _ready():
	word = get_node("Confirm/Word")
	word.text = ""
	boxes = []

func box_clicked(box):
	#print("Box (" + box.letter + ", " + str(box.value) + ") clicked")

	if box.selected and box not in boxes:
		boxes.append(box)
	elif box in boxes:
		boxes.erase(box)
	else:
		print("Something is very off...")
	
	# Update the word display
	_update_word()

func _update_word():
	var new_word = ""
	for b in boxes:
		new_word += b.letter
	word.text = new_word

func _on_clear_pressed():	
	for box in boxes:
		box.select(false)
	boxes.clear()
	_update_word()
	print("cleared " + str(len(boxes)) + " boxes")
