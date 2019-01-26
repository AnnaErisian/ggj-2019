const Event = preload("res://src/script/world/Event.gd")

class eventLoader:
	var events = {}
	
	func loadEvents():
		var file = File.new()
		file.open("res://assets/data/events.json", file.READ)
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
		
		events[eventToAdd.name] = eventToAdd