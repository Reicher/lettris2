extends Node

var save_data: SaveData

var level = 1
var score = 0
var best_word = ""

var music_on = true
var effects_on = true

func _ready():
	save_data = SaveData.load_or_create()

func save_game():
	save_data.save()
