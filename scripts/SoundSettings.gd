extends HBoxContainer

@export var music_on_texture: Texture
@export var music_off_texture: Texture
@export var effect_on_texture: Texture
@export var effect_off_texture: Texture

func _ready():
	if Global.music_on:
		$"music-toggle".texture_normal = music_on_texture
	else:
		$"music-toggle".texture_normal = music_off_texture
	if Global.sfx_on:
		$"effect-toggle".texture_normal = effect_on_texture
	else:
		$"effect-toggle".texture_normal = effect_off_texture

func _on_musictoggle_toggled(toggled_on):
	Global.music_on = not Global.music_on
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_bus_index, not Global.music_on)
	if Global.music_on:
		$"music-toggle".texture_normal = music_on_texture
	else:
		$"music-toggle".texture_normal = music_off_texture
	Global.save()

func _on_effectstoggle_toggled(toggled_on):
	Global.sfx_on = not Global.sfx_on
	var sfx_bus_index = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_mute(sfx_bus_index, not Global.sfx_on)
	if Global.sfx_on:
		$"effect-toggle".texture_normal = effect_on_texture
	else:
		$"effect-toggle".texture_normal = effect_off_texture
	Global.save()
