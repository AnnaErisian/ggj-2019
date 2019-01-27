extends Control

const ScheduleMenuItem = preload("res://src/scene/ui/Schedule.tscn")

var party

func loadScheduleMenu():
	for child in get_node("ColorRect/ScrollContainer/Schedules").get_children():
		get_node("ColorRect/ScrollContainer/Schedules").remove_child(child)
		
	party = MainData.party
	
	var count = 0
	for character in party.active:
		var scheduleItem = ScheduleMenuItem.instance()
		scheduleItem.loadCharacterData(character)
		scheduleItem.rect_min_size = Vector2(2000, 100)
		get_node("ColorRect/ScrollContainer/Schedules").add_child(scheduleItem)
