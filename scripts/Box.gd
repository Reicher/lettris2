extends RigidBody2D

signal clicked(box)

const LETTER_DATA = {
	'A': { 'value': 1, 'quantity': 9 },  'B': { 'value': 3, 'quantity': 2 },
	'C': { 'value': 3, 'quantity': 2 },  'D': { 'value': 2, 'quantity': 4 },
	'E': { 'value': 1, 'quantity': 12 }, 'F': { 'value': 4, 'quantity': 2 },
	'G': { 'value': 2, 'quantity': 3 },  'H': { 'value': 4, 'quantity': 2 },
	'I': { 'value': 1, 'quantity': 9 },  'J': { 'value': 8, 'quantity': 1 },
	'K': { 'value': 5, 'quantity': 1 },  'L': { 'value': 1, 'quantity': 4 },
	'M': { 'value': 3, 'quantity': 2 },  'N': { 'value': 1, 'quantity': 6 },
	'O': { 'value': 1, 'quantity': 8 },  'P': { 'value': 3, 'quantity': 2 },
	'Q': { 'value': 10, 'quantity': 1 }, 'R': { 'value': 1, 'quantity': 6 },
	'S': { 'value': 1, 'quantity': 4 },  'T': { 'value': 1, 'quantity': 6 },
	'U': { 'value': 1, 'quantity': 4 },  'V': { 'value': 4, 'quantity': 2 },
	'W': { 'value': 4, 'quantity': 2 },  'X': { 'value': 8, 'quantity': 1 },
	'Y': { 'value': 4, 'quantity': 2 },  'Z': { 'value': 10, 'quantity': 1 }
}

var is_selected: bool = false
var letter: String = " "
var value: int = 0
var size: Vector2 = Vector2(80, 80)

func _get_random_letter() -> String:
	var random_number = randi() % 98
	var cumulative_quantity = 0
	for key in LETTER_DATA.keys():
		cumulative_quantity += LETTER_DATA[key]['quantity']
		if cumulative_quantity > random_number:
			return key
	return ""

func _ready() -> void:
	letter = _get_random_letter()
	value = LETTER_DATA[letter].value
	adjust_special_box_properties()
	_update_display()

func adjust_special_box_properties() -> void:
	if scene_file_path.contains("Bomb"):
		print("BOMB")
	elif scene_file_path.contains("Silver"):
		value *= 2
	elif scene_file_path.contains("Gold"):
		value *= 3
	elif scene_file_path.contains("Double"):
		letter = "x2"
		value = 0
	elif scene_file_path.contains("Triple"):
		letter = "x3"
		value = 0

func _update_display() -> void:
	$"Letter/Value".text = str(value) if value != 0 else ""
	$"Letter".text = letter

func set_selected(status: bool) -> void:
	is_selected = status
	var golden_color = Color(1, 0.743, 0, 1)
	$AnimatedSprite.modulate = golden_color if is_selected else Color(1, 1, 1, 1)

func destroy() -> void:
	set_selected(false)
	$"Letter".visible = false
	$AnimatedSprite.play("Death")
	$AnimatedSprite.animation_finished.connect(queue_free)

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		set_selected(not is_selected)
		clicked.emit(self)
