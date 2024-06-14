extends TextureRect

signal box_drop_time
signal word_accepted(word)

const DICTIONARY_FILE_PATH: String = "res://assets/words_alpha.txt"

@export var score: int = 0
@export var level: int = 1

var dictionary: Array = []
var selected_boxes: Array = []
var current_word: String = ""


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

func update_score(points: int) -> void:
	score += points
	level = 1 + int(score / 10)
	var new_wait_time = max(0.5, 3 - 0.1 * (level - 1))  
	print("Time between drops: " + str(new_wait_time))
	
	$Timer.wait_time = new_wait_time
	$Score.text = str(score)
	$Level.text = "Level: " + str(level)

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
	get_node("Confirm/Word/Value").text = str(points) if points != 0 else ""
	get_node("Confirm/Word").text = current_word

func _on_clear_pressed():
	for box in selected_boxes:
		box.set_selected(false)
	selected_boxes.clear()
	_update_word()

func _on_confirm_pressed():
	if not dictionary.has(current_word.to_lower()):
		return
	
	word_accepted.emit(current_word)
	
	# If a bomb is part of it boxes might be destroyed before points could 
	# be given, tough luck..
	_handle_explosions()
	
	update_score(_get_points(selected_boxes))
	
	for box in selected_boxes:
		box.destroy()
	selected_boxes.clear()

	_update_word()
