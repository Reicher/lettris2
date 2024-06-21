extends Control

var save_data:SaveData # Shoudl maybe be in some sort of global later? 
var length:int = 5

func high_score_worthy(score)-> bool:
	save_data = SaveData.load_or_create()
	if !save_data.high_score or len(save_data.high_score) < length:
		return true
		
	for nick in save_data.high_score:
		if save_data.high_score[nick] < score:
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
	for nick in save_data.high_score:
		var label = Label.new()
		label.text = nick + ": " + str(save_data.high_score[nick])
		$Table.add_child(label)
	$Table.show()


func _on_name_select_submit(name):
	# Use name in some way? 
	save_data.high_score[name] = Global.score
	save_data.save()
	$NameSelect.hide()
	show_table()
