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

const KARMA_THRESHOLD: float = 3.5

@export var karma: float = 10
var game_over_scene: PackedScene = preload("res://scenes/GameOver.tscn")
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()  # Ensure RNG is seeded
	for box in $StartBoxes.get_children():
		initialize_box(box)

func initialize_box(box: Node) -> void:
	box.add_to_group("boxes")
	box.clicked.connect($UI.box_clicked)

func _get_next_box() -> Node:
	#return box_scenes[[BoxType.BALL, BoxType.CASE, BoxType.BIG, BoxType.NORMAL, BoxType.SILVER, BoxType.GOLD, BoxType.DOUBLE, BoxType.TRIPLE, BoxType.BOMB][rng.randi() % 9]].instantiate()
	
	var bad_boxes: Array = [BoxType.BALL, BoxType.CASE, BoxType.BIG]
	var next_box = BoxType.NORMAL

	if $UI.level >= 5 and rng.randi() % 10 == 0:
		next_box = BoxType.BOMB
	elif karma > 15:
		karma = 10
		if rng.randi() % 3 == 0:  # 1/3 chance
			next_box = BoxType.TRIPLE
		else:
			next_box = BoxType.GOLD
	elif karma > 13:
		karma = 10
		if rng.randi() % 3 == 0:  # 1/3 chance
			next_box = BoxType.DOUBLE
		else:
			next_box = BoxType.SILVER
	elif karma < 7:
		karma = 10
		next_box = bad_boxes[rng.randi() % bad_boxes.size()]

	print("Selected box type: ", next_box, " | Karma: ", karma)
	
	return box_scenes[next_box].instantiate()
	
func _on_ui_box_drop_time():
	if _check_game_over():
		get_tree().change_scene_to_packed(game_over_scene)
		return
	
	var box: Node = _get_next_box()
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

func _on_ui_word_accepted(word):
	# Karma is only depending on doing long words now, better
	karma += (word.length() - KARMA_THRESHOLD)
