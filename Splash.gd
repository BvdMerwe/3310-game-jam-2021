extends TextureRect

var timeout = 1.5 #second



func _process(delta):
	if timeout <= 0 :
		visible = false
		set_process(false)
	timeout -= delta
	pass
