extends Node2D

const EventLoader = preload("res://src/script/world/EventLoader.gd")

func _ready():
	var eventLoader = EventLoader.eventLoader.new()
	eventLoader.loadEvents()
	
	var events = eventLoader.events
	for eventName in events.keys():
		var event = events[eventName]
		print(event.name)
		print(event.options.keys())
	
	var testPartySkills = {"leadership": 4, "pathfinding": 1, "animals": 3}
	var result = events["Mild Rain"].selectOption("Push onward", testPartySkills)
	print(result)
