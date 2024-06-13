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

const KARMA_THRESHOLD: int = 5
const INITIAL_KARMA: int = 10
const DICTIONARY_FILE_PATH: String = "res://assets/words_alpha.txt"
const START_BOXES_NODE_PATH: String = "GameArea/StartBoxes"

var game_over_scene: PackedScene = preload("res://scenes/GameOver.tscn")
var box_scenes: Dictionary = {
	BoxType.NORMAL: preload("res://scenes/boxes/Box.tscn"),
	BoxType.SILVER: preload("res://scenes/boxes/Silver.tscn"),
	BoxType.GOLD: preload("res://scenes/boxes/Gold.tscn"),
	BoxType.BALL: preload("res://scenes/boxes/Ball.tscn"),
	BoxType.CASE: preload("res://scenes/boxes/Case.tscn"),
	BoxType.BOMB: preload("res://scenes/boxes/Bomb.tscn"),
	BoxType.BIG: preload("res://scenes/boxes/Big.tscn"),
	BoxType.DOUBLE: preload("res://scenes/boxes/Double.tscn"),
	BoxType.TRIPLE: preload("res://scenes/boxes/Triple.tscn")
}

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var dictionary: Array = []
var selected_boxes: Array = []
var current_word: String = ""
var karma: int = INITIAL_KARMA
var score: int = 0
var bad_boxes: Array = []

@export var level: int = 1

func load_word_list(file_path: String) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	while not file.eof_reached():
		var word: String = file.get_line().strip_edges()
		if word.length() > 2:
			dictionary.append(word)
	file.close()
	print("Loaded %d words into dictionary" % dictionary.size())

func _ready() -> void:
	load_word_list(DICTIONARY_FILE_PATH)
	_update_word()
	_update_score(0)
	for box in get_node(START_BOXES_NODE_PATH).get_children():
		initialize_box(box)

func initialize_box(box: Node) -> void:
	box.add_to_group("boxes")
	box.clicked.connect(box_clicked)

func _get_next_box_type() -> PackedScene:
	karma = 10
	if karma > 20:
		return box_scenes[BoxType.GOLD]
	elif karma > 15:
		return box_scenes[BoxType.SILVER]
	elif karma < 7 and not bad_boxes.is_empty():
		return bad_boxes[randi() % bad_boxes.size()]
	return box_scenes.values()[randi() % box_scenes.size()]

func _on_timer_timeout() -> void:
	if _check_game_over():
		get_tree().change_scene_to_packed(game_over_scene)
		return
	
	var box: Node = _get_next_box_type().instantiate()
	var viewport_width: float = get_viewport_rect().size.x
	var x_bounds: Vector2 = Vector2(box.size.x / 2, viewport_width - box.size.x / 2)
	box.position = Vector2(rng.randf_range(x_bounds.x, x_bounds.y), -box.size.y / 2)
	initialize_box(box)
	add_child(box)

func _check_game_over() -> bool:
	for box in get_tree().get_nodes_in_group("boxes"):
		if box.position.y < 0:
			return true
	return false

func box_clicked(box: Node) -> void:
	if box in selected_boxes:
		selected_boxes.erase(box)
		box.set_selected(false)
	else:
		selected_boxes.append(box)
		box.set_selected(true)
	_update_word()

func _get_points(word_boxes: Array) -> int:
	var points: int = 0
	var multiplier: int = 1
	var word: String = ""
	for box in word_boxes:
		if box.letter == "x2":
			multiplier *= 2
		elif box.letter == "x3":
			multiplier *= 3
		else:
			word += box.letter
			points += box.value
	current_word = word
	return points * multiplier

func _on_clear_pressed() -> void:
	for box in selected_boxes:
		box.set_selected(false)
	selected_boxes.clear()
	_update_word()

func _on_confirm_pressed() -> void:
	if not dictionary.has(current_word.to_lower()):
		return
	
	var points: int = _get_points(selected_boxes)
	for box in selected_boxes:
		box.destroy()
	selected_boxes.clear()
	
	karma += points - KARMA_THRESHOLD
	_update_word()
	_update_score(points)

func _update_word() -> void:
	var points: int = _get_points(selected_boxes)
	get_node("GameArea/UI/Confirm/Word/Value").text = str(points) if points != 0 else ""
	get_node("GameArea/UI/Confirm/Word").text = current_word

func _update_score(points: int) -> void:
	score += points
	level = 1 + int(score / 10)
	
	bad_boxes.clear()
	if level >= 3:
		bad_boxes.append(box_scenes[BoxType.BALL])
	if level >= 5:
		bad_boxes.append(box_scenes[BoxType.CASE])
	
	get_node("GameArea/UI/Score").text = str(score)
	get_node("GameArea/UI/Level").text = "Level: " + str(level)
