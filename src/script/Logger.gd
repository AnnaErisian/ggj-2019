extends Node

onready var itemlist = get_node("/root/Main/Camera2D/CanvasLayer/WorldHUD/EventLog")

func write(entry):
	if itemlist == null:
		itemlist = get_node("/root/Main/Camera2D/CanvasLayer/WorldHUD/EventLog")
	itemlist.write(entry)