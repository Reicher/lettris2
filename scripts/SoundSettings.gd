extends HBoxContainer

@export var music_on_texture: Texture
@export var music_off_texture: Texture
@export var effect_on_texture: Texture
@export var effect_off_texture: Texture


func _on_musictoggle_toggled(toggled_on):
	Global.music_on = not Global.music_on
	if Global.music_on:
		$"music-toggle".texture_normal = music_on_texture
		# play a little sound
	else:
		$"music-toggle".texture_normal = music_off_texture

func _on_effectstoggle_toggled(toggled_on):
	Global.effects_on = not Global.effects_on
	if toggled_on:
		$"effect-toggle".texture_normal = effect_on_texture
		# play a little sound
	else:
		$"effect-toggle".texture_normal = effect_off_texture
