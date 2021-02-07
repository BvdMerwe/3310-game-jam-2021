extends Node2D

var point = preload('res://Point.tscn')
var divisor = 18

func add_point():
	var point_inst = point.instance()
	point_inst.position.x = (get_child_count() % divisor) + (get_child_count() % divisor)
	point_inst.position.y = floor(get_child_count() / divisor) + floor(get_child_count() / divisor)
	add_child(point_inst)
	pass

func reset_points():
	for n in get_children():
		remove_child(n)
		n.queue_free()
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
