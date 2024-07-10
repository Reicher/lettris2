extends Control

var max_length: int = 5

func high_score_worthy(score) -> bool:
	if Global.high_scores.size() < max_length:
		return true
		
	for entry in Global.high_scores:
		if entry["score"] < score:
			return true
	return false

func _ready():
	if high_score_worthy(Global.score):
		$NameSelect.show()
	else:
		show_table()
		
func show_table():
	for entry in Global.high_scores:
		var label = Label.new()
		label.text = entry["nick"] + ": " + str(entry["score"])
		$Table.add_child(label)
	$Table.show()

func _on_name_select_submit(name):
	# Add new high score entry
	Global.high_scores.append({"nick": name, "score": Global.score})
	print(Global.high_scores)
	# Sort and trim to max_length
	Global.high_scores.sort_custom(func(a, b):
		return int(a["score"]) > int(b["score"])
	)
	print(Global.high_scores)
	if Global.high_scores.size() > max_length:
		Global.high_scores = Global.high_scores.slice(0, max_length)
	Global.save()
	$NameSelect.hide()
	show_table()
