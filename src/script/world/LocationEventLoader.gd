extends Node

var Event = load("res://src/script/world/Event.gd")
var events = {}

func _init():
	var folderPath = "res://assets/data/locations/"
	var files = list_files_in_directory(folderPath)
	for filename in files:
		var file = File.new()
		file.open(folderPath + filename, file.READ)
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
	eventToAdd.eventColor = Color(event["color"]) if event.has("color") else Color("#999999")
	eventToAdd.eventType = event["type"] if event.has("type") else "wilderness"
	eventToAdd.eventImmediate = event["immediate"] if event.has("immediate") else false
	
	events[eventToAdd.name] = eventToAdd

func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with("."):
            files.append(file)

    dir.list_dir_end()

    return files