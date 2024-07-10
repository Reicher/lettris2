extends Node

var level = 1
var score = 0
var best_word = ""

# Persistent data
@export var high_scores = []
@export var last_nick = "AAA"
@export var music_on = true
@export var sfx_on = true

const SAVE_PATH: String = "user://save_data.tres"

func _ready():
	load_saved_data()

func load_saved_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.ModeFlags.READ)
		var data = file.get_as_text()
		file.close()

		var saved_data = JSON.parse_string(data)
		if typeof(saved_data) == TYPE_DICTIONARY:
			high_scores = saved_data.get("high_scores", [])
			last_nick = saved_data.get("last_nick", "AAA")
			music_on = saved_data.get("music_on", true)
			sfx_on = saved_data.get("sfx_on", true)		
		print("Loaded saved data")
	else:
		print("No data to load") 

func save() -> void:
	var data = {
		"high_scores": high_scores,
		"last_nick": last_nick,
		"music_on": music_on,
		"sfx_on": sfx_on
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.ModeFlags.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
