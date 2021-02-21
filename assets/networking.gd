extends Node

# Connect all functions

var SERVER_PORT = 46594
# var SERVER_IP = '192.168.0.10'
var SERVER_IP = "130.61.188.46"
# var SERVER_IP = "0.0.0.0"
# var SERVER_IP = "127.0.0.1"

export(bool) var is_server = false

var peer
var connected = false
var failed = false
var retry = 0
var retry_max = 3
var timeout = 0
var timeout_max = 2

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = {name = "   ", score = 0}

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

	peer = NetworkedMultiplayerENet.new()
	set_process(false)

func find_server():
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	
	get_tree().set_network_peer(null) # Force reset
	get_tree().set_network_peer(peer)
	set_process(true)

	#save name
	var save_game = File.new()
	#location - ~/.local/share/godot/ | %APPDATA%\Godot\ | ~/Library/Application Support/Godot/
	save_game.open("user://user_info.save", File.WRITE)
	save_game.store_line(to_json(my_info))
	save_game.close()

func disconnect_from_server():
	peer.close_connection()
	pass

func _process(delta):
	if retry >= retry_max:
		Globals.get_game().failed_to_connect()
		# get_tree().set_pause(true)
		set_process(false)
	if failed:
		retry += 1
		print('connect failed - retrying ', retry,'/', retry_max)
	if !connected:
		if timeout >= timeout_max:
			timeout = 0
			retry += 1
			print('timed out - retrying ', retry,'/', retry_max)
			pass
		timeout += delta
	else:
		set_process(false)

	pass


func create_server():
	print('create server')
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT)
	get_tree().network_peer = peer
	pass


func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	print("connected!")
	rpc_id(id, "register_player", my_info)


func _player_disconnected(id):
	print("disconnected!")
	player_info.erase(id)  # Erase player from info.


func _connected_ok():
	connected = true
	Globals.get_game().game_connected()
	pass


func _server_disconnected():
	pass  # Server kicked us; show error and abort.


func _connected_fail():
	failed = true
	Globals.get_game().failed_to_connect()
	pass  # Could not even connect to server; abort.


remote func register_player(info):
	print("register_player!")
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info

remote func show_players(player_count):
	Globals.get_game().show_players(player_count)

remote func show_time(time):
	Globals.get_game().show_time(time)

remote func waiting_for_players():
	Globals.get_game().game_connected()

remote func game_in_progress(time, player_count):
	Globals.get_game().game_in_progress(time, player_count)

remote func game_started():
	Globals.get_game().start_game()
	print("The Game is afoot!")

func update_score(score):
	rpc_id(1, "update_score", score)

func win_time(time):
	rpc_id(1, "win_time", time)

func win_game():
	rpc_id(1, "win_game")

#function to tell people in lobby who won
remote func game_ending(player_name):
	Globals.get_game().game_ending(player_name)
	print("The Game has concluded!")

remote func game_ended(player_name, player_id):
	Globals.get_game().lose_game(player_name, player_id)
	print("The Game has concluded!")

remote func high_score(time):
	Globals.get_game().high_score(time)

remote func back_to_lobby():
	Globals.get_game().end_game()

remote func set_place(place, total):
	Globals.get_game().set_place(place, total)
