extends Button

func _pressed():
	get_tree().get_root().get_node("Main").get_node("Camera2D").get_node("CanvasLayer").get_node("ScheduleMenu").hide()