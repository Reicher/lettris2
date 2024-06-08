extends Control

var game_over = preload("res://scenes/GameOver.tscn")

# Preload the box scenes
var Normal = preload("res://scenes/boxes/Basebox.tscn")
var Silver = preload("res://scenes/boxes/Silver.tscn")
var Gold = preload("res://scenes/boxes/Gold.tscn")
var Ball = preload("res://scenes/boxes/Ball.tscn")
var Case = preload("res://scenes/boxes/Case.tscn")

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
	load_word_list("res://assets/words_alpha.txt")	
	_update_word()
	_update_score(0)
	# Connect startboxes to clicked
	var startboxes = get_node("GameArea/StartBoxes")
	for box in startboxes.get_children():
		box.clicked.connect(box_clicked)
	
func _get_next_box_type():
	# DEBUG CHAOS
	# return [Normal, Silver, Gold, Ball, Case][randi() % 5]
	
	var next = Normal
	# Nice boxes
	if karma > 20:
		next = Gold
	elif karma > 15:
		next = Silver	
	
	# Bad boxes
	if karma < 7 and not  bad_boxes.is_empty():
		next = bad_boxes[randi() % len(bad_boxes)]
	
	if next != Normal: # Reset karma if karma was served
		karma = 10
		
	return next

# A new box should be created
func _on_timer_timeout():
	# Get the viewport width and height
	var viewport_rect = get_viewport_rect()
	var viewport_width = viewport_rect.size.x

	# Check if any box is above the visible screen ( must be possible in some nicer way?)
	for child in get_children():
		if child.name != "Timer" and child.position.y < 0:
			get_tree().change_scene_to_packed(game_over)			

	var box = _get_next_box_type().instantiate()	
	
	# Generate parameters for the box
	var x_bounds = Vector2(box.size[0]/2, viewport_width - box.size[0]/2)
	box.position = Vector2(rng.randf_range(x_bounds[0], x_bounds[1]), -30)
	box.clicked.connect(box_clicked)

	add_child(box)	

func box_clicked(box):
	if box.selected and box not in selected_boxes:
		selected_boxes.append(box)
	elif box in selected_boxes:
		selected_boxes.erase(box)
	else:
		print("Something is very off...")
	
	_update_word()

func _on_clear_pressed():
	for box in selected_boxes:
		box.select(false)
	selected_boxes.clear()
	_update_word()

func _on_confirm_pressed():
	if not dictionary.has(CurrentWord.to_lower()):
		return

	var points = 0
	for box in selected_boxes:
		points += box.value
		box.start_destroy()
	selected_boxes.clear()
	
	karma += points - karma_threshold 
	
	_update_word()
	_update_score(points)
	
func _update_word():
	CurrentWord = ""
	var points = 0
	for box in selected_boxes:
		CurrentWord += box.letter
		points += box.value
	
	get_node("GameArea/UI/Confirm/Word/Value").text = str(points) if points != 0 else ""
	get_node("GameArea/UI/Confirm/Word").text = CurrentWord

func _update_score(points):
	score += points
	level = 1 + int(score / 10)
	
	bad_boxes = []
	if level >= 3:
		bad_boxes.append(Ball)
	if level >= 5:
		bad_boxes.append(Case)
	get_node("GameArea/UI/Score").text = str(score)	
	get_node("GameArea/UI/Level").text = "Level: " + str(level)
