extends Node2D

onready var p = get_parent()
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass


const roadColor = Color("#886644")

func _draw():
	for n in p.directLinkedNodes:
		draw_line(Vector2(0,0),n.position - p.position,roadColor, 8.0, true)