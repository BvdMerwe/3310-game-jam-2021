extends Node

var audio_player
var current_sound = ""

var sounds = {
	"click": preload("res://assets/sound/click.wav"),
	"click_bad": preload("res://assets/sound/click_bad.wav"),
	"win": preload("res://assets/sound/win.wav"),
	"lose": preload("res://assets/sound/lose.wav"),
}

func play_sound(sound_name):
	current_sound = sound_name
	if (!audio_player):
		audio_player = Globals.get_audio_player()
	
	audio_player.stream = sounds[sound_name]

	audio_player.play()
	pass

func play_sound_once(sound_name):
	if sound_name == current_sound: return
	current_sound = sound_name
	if (!audio_player):
		audio_player = Globals.get_audio_player()
	audio_player.stream = sounds[sound_name]

	audio_player.play()
	pass
