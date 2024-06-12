extends Control

enum BoxType {
	NORMAL,
	SILVER,
	GOLD,
	BALL,
	CASE,
	BOMB,
	BIG,
	DOUBLE,
	TRIPLE
}

var game_over = preload("res://scenes/GameOver.tscn")

# Preload the box scenes
var box_scenes = {
	BoxType.NORMAL: preload("res://scenes/boxes/Box.tscn"),
	BoxType.SILVER: preload("res://scenes/boxes/Silver.tscn"),
	BoxType.GOLD: preload("res://scenes/boxes/Gold.tscn"),
	BoxType.BALL: preload("res://scenes/boxes/Ball.tscn"),
	BoxType.CASE: preload("res://scenes/boxes/Case.tscn"),
	BoxType.BOMB: preload("res://scenes/boxes/Bomb.tscn"),
	BoxType.BIG: preload("res://scenes/boxes/Big.tscn"),
	BoxType.DOUBLE: preload("res://scenes/boxes/Double.tscn"),
	BoxType.TRIPLE: preload("res://scenes/boxes/Tripple.tscn")
}

var rng = RandomNumberGenerator.new()
var dictionary = []

var selected_boxes = []
var CurrentWord = ""
var karma = 10
var score = 0
var bad_boxes = []

@export var level = 1
@export var karma_threshold = 5

func load_word_list(file_path):    
	var file = FileAccess.open(file_path, FileAccess.READ)
	var minimum_length = 2
	while not file.eof_reached():
		var word = file.get_line().strip_edges()
		if word.length() > minimum_length:
			dictionary.append(word)
	file.close()
	print("Loaded " + str(dictionary.size()) + " words into dictionary")

func _ready():
	load_word_list("res://assets/words_alpha.txt")    
	_update_word()
	_update_score(0)
	var startboxes = get_node("GameArea/StartBoxes")
	for box in startboxes.get_children():
		initialize_box(box)

func initialize_box(box):
	box.add_to_group("boxes")
	box.clicked.connect(box_clicked)

# Needs a lot of love
func _get_next_box_type():
	if karma > 20:
		karma = 10
		return box_scenes[BoxType.GOLD]
	elif karma > 15:
		karma = 10
		return box_scenes[BoxType.SILVER]
	elif karma < 7 and not bad_boxes.is_empty():
		karma = 10
		return bad_boxes[randi() % bad_boxes.size()]
	return box_scenes.values()[randi() % box_scenes.size()]

func _on_timer_timeout():
	var viewport_rect = get_viewport_rect()
	var viewport_width = viewport_rect.size.x

	for box in get_tree().get_nodes_in_group("boxes"):
		if box.position.y < 0: # There is still a box above screen
			get_tree().change_scene_to_packed(game_over)
			return

	var box = _get_next_box_type().instantiate()    
	var x_bounds = Vector2(box.size[0] / 2, viewport_width - box.size[0] / 2)
	box.position = Vector2( rng.randf_range(x_bounds[0], x_bounds[1]), 
							-box.size[1]/2)
	initialize_box(box)
	add_child(box)

func box_clicked(box):
	if box in selected_boxes:
		selected_boxes.erase(box)
		box.select(false)
	else:
		selected_boxes.append(box)
		box.select(true)
	_update_word()

func _get_points(word_boxes: Array) -> int:
	var points = 0
	var multiplier = 1
	var word = ""
	for box in word_boxes:
		if box.letter == "x2":
			multiplier *= 2
		elif box.letter == "x3":
			multiplier *= 3
		else:
			word += box.letter
			points += box.value
	CurrentWord = word
	return points * multiplier

func _on_clear_pressed():
	for box in selected_boxes:
		box.select(false)
	selected_boxes.clear()
	_update_word()

func _on_confirm_pressed():
	if not dictionary.has(CurrentWord.to_lower()):
		return

	var points = _get_points(selected_boxes)
	for box in selected_boxes:
		box.start_destroy()
	selected_boxes.clear()
	
	karma += points - karma_threshold 
	
	_update_word()
	_update_score(points)

func _update_word():
	CurrentWord = ""
	var points = _get_points(selected_boxes)
	get_node("GameArea/UI/Confirm/Word/Value").text = str(points) if points != 0 else ""
	get_node("GameArea/UI/Confirm/Word").text = CurrentWord

func _update_score(points):
	score += points
	level = 1 + int(score / 10)
	
	bad_boxes = []
	if level >= 3:
		bad_boxes.append(box_scenes[BoxType.BALL])
	if level >= 5:
		bad_boxes.append(box_scenes[BoxType.CASE])
	get_node("GameArea/UI/Score").text = str(score)    
	get_node("GameArea/UI/Level").text = "Level: " + str(level)
