extends RigidBody2D

var DeathParticles = preload("res://scenes/components/DeathParticles.tscn")

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

const BLAST_RADIUS: float = 130.0

var is_selected: bool = false
var explosive: bool = false
var letter: String = " "
var value: int = 0
var size: Vector2 = Vector2(80, 80) # TODO, get real
var emitters: Array[GPUParticles2D] = []


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
		explosive = true
	if scene_file_path.contains("Ball"):
		_add_emitter("res://assets/images/particles/ball-piece-red.png")
		_add_emitter("res://assets/images/particles/ball-piece-redyellow.png")
		_add_emitter("res://assets/images/particles/ball-piece-yellow.png")
	elif scene_file_path.contains("Silver"):
		_add_emitter("res://assets/images/particles/silver-board1.png")
		_add_emitter("res://assets/images/particles/silver-board2.png")
		value *= 2
	elif scene_file_path.contains("Gold"):
		_add_emitter("res://assets/images/particles/gold-board1.png")
		_add_emitter("res://assets/images/particles/gold-board2.png")
		value *= 3
	elif scene_file_path.contains("Double"):
		letter = "x2"
		value = 0
	elif scene_file_path.contains("Triple"):
		letter = "x3"
		value = 0
	elif scene_file_path.contains("Case"):
		_add_emitter("res://assets/images/bowtie.png")
		_add_emitter("res://assets/images/particles/tophat.png")
		_add_emitter("res://assets/images/particles/wand.png")
		_add_emitter("res://assets/images/particles/suitcase-piece1.png")
		_add_emitter("res://assets/images/particles/suitcase-piece2.png")
		_add_emitter("res://assets/images/particles/suitcase-piece3.png")
	else: # box or bigbox
		_add_emitter("res://assets/images/particles/board1.png")
		_add_emitter("res://assets/images/particles/board2.png")
		
func _add_emitter(texture_path) -> void:
	var new_emitter = DeathParticles.instantiate()
	new_emitter.texture = load(texture_path)
	add_child(new_emitter)
	emitters.append(new_emitter)

func _update_display() -> void:
	$"Letter/Value".text = str(value) if value != 0 else ""
	$"Letter".text = letter

func set_selected(status: bool) -> void:
	is_selected = status
	$SelectEffect.emitting = is_selected
	if is_selected:
		AudioManager.letter_select.play()
		$AnimatedSprite.modulate = Color(1, 0.743, 0, 1)
	else:
		AudioManager.letter_deselect.play()
		$AnimatedSprite.modulate = Color(1, 1, 1, 1)

func destroy() -> void:
	set_selected(false)
	$Letter.visible = false
	self.collision_layer = 0	

	$AnimatedSprite.play("Death")
	$AnimatedSprite.animation_finished.connect(destroy_done)
	
	if scene_file_path.contains("Bomb"):
		AudioManager.bomb.play()
	
	for emitter in emitters:
		emitter.restart()
		emitter.finished.connect(destroy_done)
	
func destroy_done() -> void:
	if not $AnimatedSprite.is_playing():
		$AnimatedSprite.hide()
		var all_emitters_finished = true
		for emitter in emitters:
			if emitter.emitting:
				all_emitters_finished = false
				break
		if all_emitters_finished:
			queue_free()

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		set_selected(not is_selected)
		clicked.emit(self)
