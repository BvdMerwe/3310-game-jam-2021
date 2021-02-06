extends Node

# Connect all functions

var SERVER_PORT = 6969
var SERVER_IP = '127.0.0.1'

export(bool) var is_server = false

var ws
var connected = false
var failed = false
var retry = 0
var retry_max = 3
var timeout = 0
var timeout_max = 2



func _ready():
	print('wtfff')
	ws = WebSocketClient.new()
	ws.connect("connection_established", self, "_connection_established")
	ws.connect("connection_closed", self, "_connection_closed")
	ws.connect("connection_error", self, "_connection_error")
	# peer.create_client(SERVER_IP, SERVER_PORT)
	ws.connect_to_url(SERVER_IP +":"+ str(SERVER_PORT)) #HTML websocket
	get_tree().network_peer = ws


	
func _connection_established(protocol):
	print("Connection established with protocol: ", protocol)
	
func _connection_closed():
	print("Connection closed")

func _connection_error():
	print("Connection error")
	
func _process(delta):
	print(ws.get_connection_status())
	if ws.get_connection_status() == ws.CONNECTION_CONNECTING || ws.get_connection_status() == ws.CONNECTION_CONNECTED:
		print('polling')
		ws.poll()
	if ws.get_peer(1).is_connected_to_host():
		ws.get_peer(1).put_var("HI")
		if ws.get_peer(1).get_available_packet_count() > 0 :
			var test = ws.get_peer(1).get_var()
			print('recieve %s' % test)


func create_server():
	# print('create server')
	# ws = NetworkedMultiplayerENet.new()
	# ws.create_server(SERVER_PORT)
	# get_tree().network_peer = ws
	pass

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = {name = "Johnson Magenta", favorite_color = Color8(255, 0, 255)}


func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	print("connected!")
	rpc_id(id, "register_player", my_info)


func _player_disconnected(id):
	print("disconnected!")
	player_info.erase(id)  # Erase player from info.


# func _connection_established():
# 	connected = true
# 	pass  # Only called on clients, not server. Will go unused; not useful here.


func _server_disconnected():
	pass  # Server kicked us; show error and abort.


func _connected_fail():
	failed = true
	pass  # Could not even connect to server; abort.


remote func register_player(info):
	print("register_player!")
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info

	# Call function to update lobby UI here
