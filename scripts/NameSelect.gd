extends Control

signal submit(name)

var english_alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 
						'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 
						'W', 'X', 'Y', 'Z']

func _ready():
	$GridContainer/Box1/Label.text = Global.last_nick[0]
	$GridContainer/Box2/Label.text = Global.last_nick[1]
	$GridContainer/Box3/Label.text = Global.last_nick[2]
	
func get_Name() -> String:
	return ($GridContainer/Box1/Label.text + 
			$GridContainer/Box2/Label.text + 
			$GridContainer/Box3/Label.text)

func _on_up_1_pressed():
	$GridContainer/Box1/Label.text = get_next_letter($GridContainer/Box1/Label.text)

func _on_up_2_pressed():
	$GridContainer/Box2/Label.text = get_next_letter($GridContainer/Box2/Label.text)

func _on_up_3_pressed():
	$GridContainer/Box3/Label.text = get_next_letter($GridContainer/Box3/Label.text)

func _on_down_1_pressed():
	$GridContainer/Box1/Label.text = get_previous_letter($GridContainer/Box1/Label.text)

func _on_down_2_pressed():
	$GridContainer/Box2/Label.text = get_previous_letter($GridContainer/Box2/Label.text)

func _on_down_3_pressed():
	$GridContainer/Box3/Label.text = get_previous_letter($GridContainer/Box3/Label.text)

func get_next_letter(current_letter):
	var index = english_alphabet.find(current_letter)
	index = (index + 1) % english_alphabet.size()
	return english_alphabet[index]

func get_previous_letter(current_letter):
	var index = english_alphabet.find(current_letter)
	index = (index - 1 + english_alphabet.size()) % english_alphabet.size()
	return english_alphabet[index]

func _on_submit_button_pressed():
	var name = get_Name()
	Global.last_nick = name
	Global.save()
	submit.emit(name)
