extends TextureButton

class_name CustomButton

@export var button_text: String = "":
	set(value):
		button_text = value
		if $Label:
			$Label.text = button_text
	get:
		return button_text

func _init(text: String = "") -> void:
	button_text = text

func _ready() -> void:
	$Label.text = button_text

func _on_pressed():
	AudioManager.button_click_sfx.play()
