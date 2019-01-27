extends Control

const ScheduleMenuItem = preload("res://src/scene/ui/Schedule.tscn")

var party

func loadScheduleMenu():
	party = get_tree().get_root().get_node("Main").get_node("MainData").party
	
	for character in party.active:
		var scheduleItem = ScheduleMenuItem.instance()
		scheduleItem.loadCharacterData(character)
		get_node("ColorRect/ScrollContainer/Schedules").add_child(scheduleItem)
		
