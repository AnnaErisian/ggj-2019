extends Control

const ScheduleMenuItem = preload("res://src/scene/ui/Schedule.tscn")
const MAX_WIDTH = 2000

var party

func loadScheduleMenu():
	for child in get_node("ColorRect/ScrollContainer/Schedules").get_children():
		get_node("ColorRect/ScrollContainer/Schedules").remove_child(child)
		
	party = MainData.party
	
	var count = 0
	for character in party.active:
		var scheduleItem = ScheduleMenuItem.instance()
		scheduleItem.loadCharacterData(character)
		scheduleItem.rect_min_size = Vector2(MAX_WIDTH, 100)
		get_node("ColorRect/ScrollContainer/Schedules").add_child(scheduleItem)

func _input(event):
	if self.visible and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed() and get_node("ColorRect/ScrollContainer/Schedules").get_rect().has_point(event.position):
		self.on_click(event)

func on_click(event):
	var idx = int((event.position.y + get_node("ColorRect/ScrollContainer").scroll_vertical) / 100)
	if idx < get_node("ColorRect/ScrollContainer/Schedules").get_child_count():
		get_node("ColorRect/ScrollContainer/Schedules").get_child(idx).addRequestPoint(event.position.x + get_node("ColorRect/ScrollContainer").scroll_horizontal)
	
func requestTime():
	for schedule in get_node("ColorRect/ScrollContainer/Schedules").get_children():
		schedule.submitRequest()
	loadScheduleMenu()