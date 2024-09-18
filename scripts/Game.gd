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

const KARMA_THRESHOLD: float = 3.3
const MAX_KARMA: float = 20.0
const MIN_KARMA: float = 0.0
const MID_KARMA: float = 10.0

@export var karma: float = 10
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
	
func _get_next_box() -> Node:
	var good_karma_factor = (karma - MID_KARMA) / (MAX_KARMA - MID_KARMA)
	var bad_karma_factor = (MID_KARMA - karma) / MID_KARMA
	
	var weights = {
		BoxType.NORMAL: 3.0,
		BoxType.BOMB: (1.0 if Global.level >= 5 else 0.0),
		BoxType.SILVER: (2.0 * good_karma_factor if karma > MID_KARMA else 0.0),
		BoxType.GOLD: (1.5 * good_karma_factor if karma > MID_KARMA else 0.0),
		BoxType.DOUBLE: (1.0 * good_karma_factor if karma > MID_KARMA else 0.0),
		BoxType.TRIPLE: (0.5 * good_karma_factor if karma > MID_KARMA else 0.0),
		BoxType.BALL: (1.5 * bad_karma_factor if karma < MID_KARMA else 0.0),
		BoxType.CASE: (1.5 * bad_karma_factor if karma < MID_KARMA else 0.0),
		BoxType.BIG: (1.0 * bad_karma_factor if karma < MID_KARMA else 0.0),
	}
	var total_weight = 0.0

	# Calculate total weight
	for weight in weights.values():
		total_weight += weight
		
	# Randomly select a box based on weights
	var rand_value = rng.randf_range(0, total_weight)
	var cumulative_weight = 0.0
	for box_type in weights.keys():
		cumulative_weight += weights[box_type]
		if rand_value <= cumulative_weight:
			# Adjust karma after selecting a box
			if box_type in [BoxType.SILVER, BoxType.GOLD, 
							BoxType.DOUBLE, BoxType.TRIPLE]:
				karma -= 0.5  # Slightly decrease karma
			elif box_type in [BoxType.BALL, BoxType.CASE, BoxType.BIG]:
				karma += 0.5  # Slightly increase karma
			# Clamp karma within bounds
			karma = clamp(karma, MIN_KARMA, MAX_KARMA)
			return box_scenes[box_type].instantiate()

	# Default to normal box if none selected
	return box_scenes[BoxType.NORMAL].instantiate()

	
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
	
	print("karma right now:" + str(karma))
	
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
