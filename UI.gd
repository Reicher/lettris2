extends TextureRect

var boxes = []
var word = ""
var word_points = 0
var score = 0

func _ready():
	get_node("Confirm/Word").text = word # 
	get_node("Score").text = str(score)

func box_clicked(box):
	#print("Box (" + box.letter + ", " + str(box.value) + ") clicked")

	if box.selected and box not in boxes:
		boxes.append(box)
	elif box in boxes:
		boxes.erase(box)
	else:
		print("Something is very off...")
	
	_update_word()

func _update_word():
	word = ""
	word_points = 0
	for box in boxes:
		word += box.letter
		word_points += box.value
	get_node("Confirm/Word").text = word

func _on_clear_pressed():	
	for box in boxes:
		box.select(false)
	boxes.clear()
	_update_word()
	print("cleared " + str(len(boxes)) + " boxes")

func _on_confirm_pressed():
	var word_valid = true
	if not word_valid:
		# notify in some way
		return
		
	score += word_points
	get_node("Score").text = str(score)
	print(score)
	for box in boxes:
		box.destory()
	boxes.clear()
	_update_word()
	print("Removed " + str(len(boxes)) + " boxes")
		
		
