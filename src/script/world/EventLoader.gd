func loadEvents():
	var file = File.new()
	file.open("res://assets/data/events.json", file.READ)
	var json = file.get_as_text()
	var jsonresult = JSON.parse(json)
	file.close()
	
	print(jsonresult.get_result()["Mild Rain"]["name"])
	print(jsonresult.get_result()["Mild Rain"]["description"])