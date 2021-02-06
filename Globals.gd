extends Node

const LOADING = "Loading"
const CONNECTING = "Connecting"
const CONNECT_FAIL = "Connect failed :("
const CONNECT_SUCCESS = "Connected waiting for players"

const GAME_IN_PROGRESS = "Game in progress"
const GAME_ENDING = "Game ending"
const WIN_GAME = "You WIN!"
const LOSE_GAME = "You lose! :("
const HIGH_SCORE = "NEW HIGH SCORE!"


enum GameState {
	PLAYING,
	WIN,
	LOSE,
	LOBBY,
	MENU
}

var state = GameState.MENU

func get_game():
	return get_node("/root/game")

func get_audio_player():
	return get_node("/root/game/AudioStreamPlayer")