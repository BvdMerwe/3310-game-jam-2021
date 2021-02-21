extends Control

func _process(event):
	if Input.is_action_just_pressed("enter"):
		if ($Menu2.visible):
			Globals.get_game().play()
			set_process(false)
		else :
			$Menu1.visible = false
			$Menu2.visible = true
			$Menu1.set_process(false)
			$Menu2.set_process(true)
	if Input.is_action_just_pressed("ui_cancel"):
		if ($Menu2.visible):
			$Menu1.visible = true
			$Menu2.visible = false
			$Menu1.set_process(true)
			$Menu2.set_process(false)
		# else :
		# 	get_tree().quit()
	if Input.is_action_just_pressed("space") && Globals.state == Globals.GameState.MENU:
		if $Menu1/Welcome.visible :
			$Menu1/Help.visible = true
			$Menu1/Welcome.visible = false
		else :
			$Menu1/Help.visible = false
			$Menu1/Welcome.visible = true
