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
	if event is InputEventKey and event.pressed and not event.echo and event.scancode == KEY_ESCAPE:
		Logger.write("start " + str(menuDelay))
		var pauseMenu = get_node("/root/Main/Camera2D/CanvasLayer/PauseMenu")
		if pauseMenu.is_visible():
			pauseMenu.hide()
			Logger.write("is visible")
		elif !pauseMenu.is_visible():
			Logger.write("is not visible")
			pauseMenu.show()

		#Logger.write("Input received - " + str(currTime))
		Logger.write("end")