extends Node

var audio_player

var sounds = {
	"click": preload("res://assets/sound/C5.wav")
}

func play_sound(sound_name):
	if (!audio_player):
		audio_player = Globals.get_audio_player()
	
	audio_player.stream = sounds[sound_name]

	audio_player.play()
	pass
