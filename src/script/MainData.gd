extends Node



var currTime = 0
var party = null

signal time_updated

# params: int timeToAdd
func addTime(timeToAdd):
	currTime += timeToAdd
	emit_signal("time_updated")
	

func _input(event):
	if event is InputEventKey and event.scancode == KEY_ESCAPE:
		#currTime += 1
		#emit_signal("time_updated")
		Logger.write("Input received - " + str(currTime))