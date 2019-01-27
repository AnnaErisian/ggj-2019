extends Node

var Event = load("res://src/script/world/Event.gd")
var events = {}

func _init():
	var file = File.new()
	file.open("res://assets/data/locations.json", file.READ)
	var json = file.get_as_text()
	var jsonresult = JSON.parse(json)
	file.close()
	
	for result in jsonresult.get_result().keys():
		parseEvent(jsonresult.get_result()[result])

# params: dictionary event
func parseEvent(event):
	var eventToAdd = Event.event.new()
	eventToAdd.name = event["name"]
	eventToAdd.description = event["description"]
	eventToAdd.time = event["time"]
	eventToAdd.options = event["options"]
	eventToAdd.internal = event.has("internal")
	
	events[eventToAdd.name] = eventToAdd