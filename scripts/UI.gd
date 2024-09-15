extends NinePatchRect

signal box_drop_time
signal word_accepted(word)

const DICTIONARY_FILE_PATH: String = "res://assets/words_alpha.txt"

var dictionary: Array = []
var selected_boxes: Array = []
var current_word: String = ""
var best_word_score = 0

# Nodes
@onready var score_label = $InnerMargin/Info/score_num
@onready var level_label = $InnerMargin/Info/level_num
@onready var confirm_word_label =  $InnerMargin/Buttons/Confirm/Margins/Word
@onready var confirm_value_label =  $InnerMargin/Buttons/Confirm/Margins/Value
@onready var clear_button = $InnerMargin/Buttons/Clear

func load_word_list(file_path: String) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	while not file.eof_reached():
		var word: String = file.get_line().strip_edges()
		if word.length() > 2:
			dictionary.append(word)
	file.close()
	print("Loaded %d words into dictionary" % dictionary.size())

func _ready():	
	load_word_list(DICTIONARY_FILE_PATH)			
	_update_word()
	Global.score = 0
	update_score(0)

func update_score(points: int) -> void:
	Global.score += points
	Global.level = 1 + int(Global.score / 10)
	
	# TODO: Do not count multiples or silver/gold either.
	if points > best_word_score:
		Global.best_word = current_word
		best_word_score = points
	
	#var new_wait_time = max(0.5, 3 - 0.1 * (Global.level - 1))  
	var new_wait_time = 0.4 # To test
	print("Time between drops: " + str(new_wait_time))
	
	$Timer.wait_time = new_wait_time
	score_label.text = str(Global.score)
	level_label.text = str(Global.level)

func _on_timer_timeout():
	box_drop_time.emit()

func _get_points(word_boxes: Array) -> int:
	var points: int = 0
	var multiplier: int = 1
	var word: String = ""
	for box in word_boxes:
		if box.letter == "x2":
			multiplier += 1
		elif box.letter == "x3":
			multiplier += 2
		else:
			word += box.letter
			points += box.value
	current_word = word
	
	return points * multiplier
	
func box_clicked(box: Node) -> void:
	# Your implementation of box_clicked logic here
	if box in selected_boxes:
		selected_boxes.erase(box)
		box.set_selected(false)
	else:
		selected_boxes.append(box)
		box.set_selected(true)
	_update_word()

func _handle_explosions() -> void:
	var boxes = get_tree().get_nodes_in_group("boxes")
	for box in selected_boxes:
		if box.explosive:
			for other_box in boxes:
				var distance = other_box.position.distance_to(box.position)
				if distance <= box.BLAST_RADIUS:
					box_clicked(other_box)
					other_box.destroy()
					
			print("Bomb exploded! Destroyed nearby boxes.")

func _update_word() -> void:
	var points: int = _get_points(selected_boxes)
	confirm_value_label.text = str(points) if points != 0 else ""
	confirm_word_label.text = current_word

func _on_clear_pressed():
	for box in selected_boxes:
		box.set_selected(false)
	selected_boxes.clear()
	_update_word()

func _on_confirm_pressed():
	if not dictionary.has(current_word.to_lower()):
		AudioManager.word_not_accepted.play()
		return
	
	AudioManager.word_accepted.play()
	word_accepted.emit(current_word)
	
	# If a bomb is part of it boxes might be destroyed before points could 
	# be given, tough luck..
	_handle_explosions()
	
	var points = _get_points(selected_boxes)
	update_score(points)
		
	for box in selected_boxes:
		box.destroy()
	selected_boxes.clear()

	_update_word()
