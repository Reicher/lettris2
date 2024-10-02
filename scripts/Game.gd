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

const KARMA_THRESHOLD: float = 3.5 # word length more than this -> good karma
const KARMA_NORMALIZE: float = 0.05 # How much we drift toward normal per drop
const MAX_KARMA: float = 10.0
const MIN_KARMA: float = 0.0
const MID_KARMA: float = (MAX_KARMA + MIN_KARMA) / 2

@export var karma: float = MID_KARMA
var game_over_scene: PackedScene = preload("res://scenes/GameOver.tscn")
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:	
	rng.randomize()  # Ensure RNG is seeded
	for box in $StartBoxes.get_children():
		initialize_box(box)
		
	resize_walls_and_floors()

func initialize_box(box: Node2D) -> void:
	box.add_to_group("boxes")
	box.clicked.connect($UI.box_clicked)

func get_box_type_name(box_type):
	return str(box_type).replace("BoxType.", "")

func calculate_weights() -> Dictionary:
	var good_karma_factor = abs((karma - MID_KARMA) / (MAX_KARMA - MID_KARMA))
	var bad_karma_factor = abs((MID_KARMA - karma) / MID_KARMA)
	
	return {
		BoxType.NORMAL: 3.0,
		BoxType.BOMB: (0.5 if Global.level >= 5 else 0.0),
		BoxType.SILVER: (2.0 * good_karma_factor if karma > MID_KARMA else 0.0),
		BoxType.GOLD: (1.5 * good_karma_factor if karma > MID_KARMA else 0.0),
		BoxType.DOUBLE: (0.4 * good_karma_factor if karma > MID_KARMA else 0.0),
		BoxType.TRIPLE: (0.2 * good_karma_factor if karma > MID_KARMA else 0.0),
		BoxType.BALL: (1.5 * bad_karma_factor if karma < MID_KARMA else 0.0),
		BoxType.CASE: (1.5 * bad_karma_factor if karma < MID_KARMA else 0.0),
		BoxType.BIG: (1.0 * bad_karma_factor if karma < MID_KARMA else 0.0),
	}

func print_drop_chances(weights, total_weight):
	print("Drop Chances:")
	for box_type in weights.keys():
		var weight = weights[box_type]
		if weight > 0:
			var percentage = (weight / total_weight) * 100
			var box_type_name = get_box_type_name(box_type)
			print("  " + box_type_name + ": " + str(round(percentage)) + "%")

func select_box(weights, total_weight) -> Node:
	var rand_value = rng.randf_range(0, total_weight)
	var cumulative_weight = 0.0
	var sorted_box_types = weights.keys()
	sorted_box_types.sort()
	for box_type in sorted_box_types:
		cumulative_weight += weights[box_type]
		if rand_value <= cumulative_weight:
			return box_scenes[box_type].instantiate()
	return box_scenes[BoxType.NORMAL].instantiate()

func _get_next_box() -> Node:
	karma = move_toward(karma, MID_KARMA, KARMA_NORMALIZE) 	# Normalize karma towards MID_KARMA
	karma = clamp(karma, MIN_KARMA, MAX_KARMA) # Clamp karma within bounds

	# Calculate weights
	var weights = calculate_weights()
	var total_weight = weights.values().reduce(func(accum, number): return accum + number)

	# Print drop chances
	print_drop_chances(weights, total_weight)

	# Select and return the box
	var box = select_box(weights, total_weight)

	return box

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
	var karma_change = (word.length() - KARMA_THRESHOLD)
	karma += karma_change
	karma = clamp(karma, MIN_KARMA, MAX_KARMA)	
	
func _on_resized():
	resize_walls_and_floors()
	
func resize_walls_and_floors():
	var ui_height = $UI.get_global_rect().size.y
	var root_size = get_global_rect().size
	var floor_y_position = root_size.y - ui_height  # Position at the top of the UI
	
	# Set the position of the WallsAndFloor node
	$WallsAndFloor.position = Vector2(0, floor_y_position)

	# Update the Floor CollisionShape2D segment shape
	var segment_shape = $WallsAndFloor/Floor.shape as SegmentShape2D
	segment_shape.a = Vector2(0, 0)
	segment_shape.b = Vector2(root_size.x, 0)

	# Update the LeftWall CollisionShape2D segment shape
	var left_wall_shape = $WallsAndFloor/LeftWall.shape as SegmentShape2D
	left_wall_shape.a = Vector2(0, 0)
	left_wall_shape.b = Vector2(0, -floor_y_position)

	# Update the RightWall CollisionShape2D segment shape
	var right_wall_shape = $WallsAndFloor/RightWall.shape as SegmentShape2D
	right_wall_shape.a = Vector2(root_size.x, 0)
	right_wall_shape.b = Vector2(root_size.x, -floor_y_position)
