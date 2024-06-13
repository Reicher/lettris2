extends TextureRect

signal confirm
signal clear


func _on_confirm_pressed():
	confirm.emit()
	
func _on_clear_pressed():
	clear.emit()
