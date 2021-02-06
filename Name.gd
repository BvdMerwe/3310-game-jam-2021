extends Control

var letters = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-!$#[]"

onready var player_name = "    "
var arrow_index = 0
var timeout = 0


func _ready():
	var save_game = File.new()
	if not save_game.file_exists("user://user_info.save"):
		player_name = "    "
	else:
		save_game.open("user://user_info.save", File.READ)
		while save_game.get_position() < save_game.get_len():
			player_name = parse_json(save_game.get_line())["name"]

	pass


func _process(_delta):
	if get_parent().visible:
		Networking.my_info["name"] = player_name.strip_edges()

		set_name(player_name)
		if timeout > 0:
			timeout -= _delta
		if Input.is_action_just_pressed("ui_right"):
			arrow_index = (arrow_index + 1) % 4
			$Arrows.position = find_node("Space" + str(arrow_index)).position
		if Input.is_action_just_pressed("ui_left"):
			arrow_index = (arrow_index - 1) % 4
			if arrow_index < 0:
				arrow_index = 3
			$Arrows.position = find_node("Space" + str(arrow_index)).position
		if timeout <= 0 && Input.is_action_pressed("ui_up"):
			timeout = 0.1
			player_name[arrow_index] = get_char(find_node("Name" + str(arrow_index)).text, 1)
		if timeout <= 0 && Input.is_action_pressed("ui_down"):
			timeout = 0.1
			player_name[arrow_index] = get_char(find_node("Name" + str(arrow_index)).text, -1)


#return character plus incrementor
func get_char(character, incrementor):
	var index = letters.find(character)
	if index < 0:
		return letters[letters.length() - 1]
	return letters[(index + incrementor) % letters.length()]


func set_name(player_name):
	for c in range(player_name.length()):
		find_node("Name" + str(c)).text = player_name[c]
