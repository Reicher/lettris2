extends NinePatchRect

var threshold = Vector2(20, 20)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Best_word.text = Global.best_word
	set_custom_minimum_size($Best_word.size + threshold)
