extends Control

# params: Character character
func loadCharacterData(character):
	get_node("name").text = character.name
	var schedule = character.schedule
	for obligation in schedule.obligations:
		var startPoint = Vector2(obligation.startTime, 25)
		var endPoint = Vector2(obligation.endTime, 25)
		var obLine = Line2D.new()
		obLine.add_point(startPoint)
		obLine.add_point(endPoint)
		obLine.default_color = Color(256, 0, 0)
		obLine.width = 10
		obLine.begin_cap_mode = obLine.LINE_CAP_ROUND
		obLine.end_cap_mode = obLine.LINE_CAP_ROUND
		add_child(obLine)
		print("Obligation from " + str(startPoint) + " to " + str(endPoint))
	print("Loaded " + character.name)