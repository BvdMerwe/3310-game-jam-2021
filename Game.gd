extends Control

func _input(event):

	if (event.is_action_pressed("ui_accept") || 
		event.is_action_pressed("ui_cancel") || 
		event.is_action_pressed("ui_up") || 
		event.is_action_pressed("ui_down") || 
		event.is_action_pressed("ui_right") || 
		event.is_action_pressed("ui_left") ) :
		AudioManager.play_sound("click")
		pass

	if Input.is_action_just_pressed("ui_cancel"):
		goto_main_menu()

func play():
	if !$Viewport/MainMenu.visible:
		return
	$Viewport/MainMenu.visible = false
	# $Viewport/Screen.visible = true
	$Viewport/Lobby.visible = true
	$Viewport/Lobby/NetworkState.text = Globals.CONNECTING
	$Viewport/Lobby/AnimationPlayer.play("Loading")
	Networking.find_server()
	Globals.state == Globals.GameState.LOBBY

func game_connected():
	$Viewport/Lobby/AnimationPlayer.play("Loaded")
	$Viewport/Lobby/NetworkState.text = Globals.CONNECT_SUCCESS

func show_players(player_count):
	pass

func show_time(time):
	$Viewport/Lobby/AnimationPlayer.play("Loaded")
	$Viewport/Lobby/NetworkState.text = "Start in " + str(time)

func start_game():
	$Viewport/Screen/Winner.visible = false
	$Viewport/Lobby.visible = false
	$Viewport/Screen.visible = true
	Globals.state = Globals.GameState.PLAYING
	$Viewport/Screen.reset_score()
	$Viewport/Screen.set_process(true)

func end_game():
	$Viewport/Screen.reset_score()
	$Viewport/Screen.visible = false
	$Viewport/Screen/Winner.visible = false
	$Viewport/Lobby.visible = true
	Globals.state == Globals.GameState.LOBBY

func game_ending(winner):
	$Viewport/Lobby/NetworkState.text = "%s won the game" % [winner]

func failed_to_connect():
	$Viewport/Lobby/AnimationPlayer.play("Loaded")
	$Viewport/Lobby/NetworkState.text = Globals.CONNECT_FAIL

func game_in_progress(time):
	if time < 1:
		game_ending("finding out who")
		return
	$Viewport/Lobby/AnimationPlayer.play("Loaded")
	$Viewport/Lobby/NetworkState.text = "%s\nmax %ss left" % [Globals.GAME_IN_PROGRESS, str(time + 15)]
	$Viewport/Screen/GameProgress.value = (time / 60) * 100

func goto_main_menu():
	Networking.disconnect_from_server()
	for _i in $Viewport.get_children():
		_i.visible = false
	$Viewport/MainMenu.visible = true
	$Viewport/MainMenu.set_process(true)
	Globals.state = Globals.GameState.MENU

	
func lose_game(player_name, player_id):
	if (player_id == get_tree().get_network_unique_id()):
		win_game(false)
		return
	if !$Viewport/Screen/Winner.visible:
		$Viewport/Screen/Winner/Label.text = "%s finished first \n%s" % [player_name, Globals.LOSE_GAME]
		$Viewport/Screen/Winner.visible = true
		$Viewport/Screen.reset_score()
		$Viewport/Screen.set_process(false)
	
func win_game(natural):
	if natural:
		Networking.win_game()
	$Viewport/Screen/Winner/Label.text = Globals.WIN_GAME
	$Viewport/Screen/Winner.visible = true
	$Viewport/Screen.reset_score()
	$Viewport/Screen.set_process(false)

func high_score(time):
	$Viewport/Screen/Winner/Label.text = "%s %s %ss" % [Globals.WIN_GAME, Globals.HIGH_SCORE, str(time)]

	
func update_score(score):
	Networking.update_score(score)

func set_place(pos, total):
	$Viewport/Screen/Position.text = "%s/%s" % [pos, total]
