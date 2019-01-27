extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var itemlist = get_node("/root/Main/Camera2D/CanvasLayer/WorldHUD/EventLog")

func _ready():
	pass

func write(entry):
	itemlist.write(entry)


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
