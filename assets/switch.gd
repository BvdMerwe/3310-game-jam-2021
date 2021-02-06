extends Control

enum SwitchState {
	ON,
	OFF
}

var switch_state = SwitchState.OFF
var score = 0

func swtich_on():
	switch_state = SwitchState.ON
	$Switch.scale.y = -1
	add_score()
	pass

func swtich_off():
	switch_state = SwitchState.OFF
	$Switch.scale.y = 1
	add_score()
	pass

func flip_swtich():
	$Switch.scale.y *= -1
	pass

func reset_score():
	score = 0
	$Points.reset_points()
	Globals.state = Globals.GameState.PLAYING
	Globals.get_game().update_score(score)
	pass

func add_score():
	score += 1
	$Points.add_point()
	Globals.get_game().update_score(score)
	pass

func _process(delta):
	match Globals.state:
		Globals.GameState.PLAYING:
			# if Input.is_action_pressed("ui_select"):
			# 	swtich_on()
			match switch_state:
				SwitchState.OFF:		
					if Input.is_action_just_pressed("ui_up"):
						swtich_on()
					elif Input.is_action_just_pressed("ui_down"):
						reset_score()
				SwitchState.ON:
					if Input.is_action_just_pressed("ui_down"):
						swtich_off()
					elif Input.is_action_just_pressed("ui_up"):
						reset_score()
			
			if score >= pow($Points.divisor, 2):
				Globals.state = Globals.GameState.WIN
		Globals.GameState.WIN:
			print("WIN")
			Globals.get_game().win_game(true)
		Globals.GameState.LOSE:
			print("LOSE")
