extends TextureRect

var dictionary = []
var selected_boxes = []
var word = ""
var word_points = 0
var score = 0

func load_word_list(file_path):	
	# Open the text file
	var file = FileAccess.open(file_path, FileAccess.READ)
	var minimum_length = 2 # All words needs to be atleast 3 char long
	while not file.eof_reached():
		var word = file.get_line()
		if len(word) > minimum_length:
			dictionary.append(word)
	file.close()
	print("Loaded " + str(len(dictionary)) + " words into dictionary")

func _ready():
	load_word_list("res://assets/words_alpha.txt" )
	
	update_word_display()
	update_score_display()

func box_clicked(box):
	if box.selected and box not in selected_boxes:
		selected_boxes.append(box)
	elif box in selected_boxes:
		selected_boxes.erase(box)
	else:
		print("Something is very off...")
	
	_update_word()

func _update_word():
	word = ""
	word_points = 0
	for box in selected_boxes:
		word += box.letter
		word_points += box.value
	update_word_display()

func _on_clear_pressed():
	for box in selected_boxes:
		box.select(false)
	selected_boxes.clear()
	_update_word()

func _on_confirm_pressed():
	var word_valid = true  # Add your validation logic here
	if not dictionary.has(word.to_lower()):
		print(word + " not in wordlist")
		return

	score += word_points
	update_score_display()
	print(score)
	for box in selected_boxes:
		box.destroy()
	selected_boxes.clear()
	_update_word()

func update_word_display():
	get_node("Confirm/Word").text = word

func update_score_display():
	get_node("Score").text = str(score)
