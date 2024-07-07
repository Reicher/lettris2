extends Control

var length:int = 5

var high_score = Global.high_score

func high_score_worthy(score)-> bool:
	if len(high_score) < length:
		return true
		
	for nick in high_score:
		if high_score[nick] < score:
			return true # Someone had worse score
	return false

# Called when the node enters the scene tree for the first time.
func _ready():
	if high_score_worthy(Global.score):
		print("new high score")
		$NameSelect.show()
	else:
		show_table()
		
func show_table():
	# Get the high scores as a list of tuples and sort them
	var high_score_list = high_score.keys()
	high_score_list.sort_custom(func(a, b):
		return int(high_score[b]) - int(high_score[a]) # Sort in descending order based on score
	)
	
	# Display the sorted high scores
	for nick in high_score_list:
		var score = high_score[nick]
		var label = Label.new()
		label.text = nick + ": " + str(score)
		$Table.add_child(label)
	$Table.show()


func _on_name_select_submit(name):
	# Use name in some way? 
	high_score[name] = Global.score
	Global.save()
	$NameSelect.hide()
	show_table()
