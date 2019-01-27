extends Node

var currTime = 0
var party = null

signal time_updated

# params: int timeToAdd
func addTime(timeToAdd):
	currTime += timeToAdd
	emit_signal("time_updated")

# Opens the pause menu
func _input(event):
	print(event)
	if event is InputEventKey and event.pressed and not event.echo and event.scancode == KEY_ESCAPE:
		var pauseMenu = get_node("/root/Main/Camera2D/CanvasLayer/PauseMenu")
		if pauseMenu != null:
			pauseMenu.loadLists()
			if pauseMenu.is_visible():
				pauseMenu.hide()
			elif !pauseMenu.is_visible():
				pauseMenu.show()