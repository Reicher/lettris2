extends Node

var level = 1
var score = 0
var best_word = ""

@export var high_score = {}
@export var last_nick = "AAA"
@export var music_on = true
@export var sfx_on = true

const SAVE_PATH: String = "user://save_data.tres"

func _ready():
	# Ensure to call load when the node is ready
	load_saved_data()

func load_saved_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.ModeFlags.READ)
		var data = file.get_as_text()
		file.close()

		var saved_data = JSON.parse_string(data)
		if typeof(saved_data) == TYPE_DICTIONARY:
			level = saved_data.get("level", 1)
			score = saved_data.get("score", 0)
			best_word = saved_data.get("best_word", "")
			high_score = saved_data.get("high_score", {})
			last_nick = saved_data.get("last_nick", "AAA")
			music_on = saved_data.get("music_on", true)
			sfx_on = saved_data.get("sfx_on", true)

func save() -> void:
	var data = {
		"level": level,
		"score": score,
		"best_word": best_word,
		"high_score": high_score,
		"last_nick": last_nick,
		"music_on": music_on,
		"sfx_on": sfx_on
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.ModeFlags.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
