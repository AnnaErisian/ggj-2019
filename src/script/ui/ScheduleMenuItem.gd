extends Control

const OBLIGATION_HEIGHT = 25
const OBLIGATION_SCALE = 5
const MAX_WIDTH = 2000

var requestPoint1
var requestPoint2
var requestLine
var character

# params: Character chr
func loadCharacterData(chr):
	character = chr
	
	get_node("name").text = character.name
	var schedule = character.schedule
	
	createVerticalLines()
	
	for obligation in schedule.obligations:
		var startPoint = Vector2((obligation.startTime - MainData.currTime)*OBLIGATION_SCALE, OBLIGATION_HEIGHT)
		var endPoint = Vector2((obligation.endTime - MainData.currTime)*OBLIGATION_SCALE, OBLIGATION_HEIGHT)
		var obLine = Line2D.new()
		obLine.add_point(startPoint)
		obLine.add_point(endPoint)
		obLine.default_color = Color(256, 0, 0)
		obLine.width = 10
		obLine.begin_cap_mode = obLine.LINE_CAP_ROUND
		obLine.end_cap_mode = obLine.LINE_CAP_ROUND
		add_child(obLine)
	print("Loaded " + character.name)
	
func createVerticalLines():
	var currX = OBLIGATION_SCALE * 24
	while currX < MAX_WIDTH:
		var startPoint = Vector2(currX, 0)
		var endPoint = Vector2(currX, 100)
		var obLine = Line2D.new()
		obLine.add_point(startPoint)
		obLine.add_point(endPoint)
		obLine.default_color = Color(0, 0, 0)
		obLine.width = 5
		obLine.begin_cap_mode = obLine.LINE_CAP_ROUND
		obLine.end_cap_mode = obLine.LINE_CAP_ROUND
		add_child(obLine)
		currX += OBLIGATION_SCALE * 24
	
func addRequestPoint(x):
	if requestPoint1 == null or (requestPoint1 != null and requestPoint2 != null):
		if requestLine != null:
			remove_child(requestLine)
		requestLine = null
		requestPoint2 = null
		requestPoint1 = Vector2(x - (int(x) % 5), 75)
	else:
		requestPoint2 = Vector2(x - (int(x) % 5), 75)
		requestLine = Line2D.new()
		requestLine.add_point(requestPoint1)
		requestLine.add_point(requestPoint2)
		requestLine.default_color = Color(0, 256, 0)
		requestLine.width = 10
		requestLine.begin_cap_mode = requestLine.LINE_CAP_ROUND
		requestLine.end_cap_mode = requestLine.LINE_CAP_ROUND
		add_child(requestLine)
	
	
	
	
	
	
	
	
	