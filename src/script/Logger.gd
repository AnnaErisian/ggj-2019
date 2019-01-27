extends Node

onready var itemlist = get_node("/root/Main/Camera2D/CanvasLayer/WorldHUD/EventLog")

func write(entry):
	itemlist.write(entry)