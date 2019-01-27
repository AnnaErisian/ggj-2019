extends Control

const Obligation = preload("res://src/script/mechanics/obligation.gd")

const OBLIGATION_HEIGHT = 33
const OBLIGATION_SCALE = 5
const REQUEST_HEIGHT = 66
const MAX_WIDTH = 24*5*30

var requestPoint1
var requestPoint2
var requestStartPointLine
var requestLine
var character
var schedule

# params: Character chr
func loadCharacterData(chr):
	character = chr
	
	get_node("name").text = character.name
	schedule = character.schedule
	
	createVerticalLines()
	createHorizontalLines()
	
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
	
	if schedule.requestedTime != null:
		addRequestPoint((schedule.requestedTime.startTime - MainData.currTime)*OBLIGATION_SCALE)
		addRequestPoint((schedule.requestedTime.endTime - MainData.currTime)*OBLIGATION_SCALE)

func createVerticalLines():
	var currX = OBLIGATION_SCALE * (24 - MainData.currTime)
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

func createHorizontalLines():
	var startPoint = Vector2(0, 100)
	var endPoint = Vector2(MAX_WIDTH, 100)
	var obLine = Line2D.new()
	obLine.add_point(startPoint)
	obLine.add_point(endPoint)
	obLine.default_color = Color(0, 0, 0)
	obLine.width = 5
	obLine.begin_cap_mode = obLine.LINE_CAP_ROUND
	obLine.end_cap_mode = obLine.LINE_CAP_ROUND
	add_child(obLine)

func addRequestPoint(x):
	if requestPoint1 == null or (requestPoint1 != null and requestPoint2 != null):
		if requestLine != null:
			remove_child(requestLine)
		requestLine = null
		requestPoint2 = null
		requestPoint1 = Vector2(x - (int(x) % 5), REQUEST_HEIGHT)
		
		requestStartPointLine = Line2D.new()
		requestStartPointLine.add_point(requestPoint1)
		requestStartPointLine.add_point(Vector2(requestPoint1.x+1, requestPoint1.y))
		requestStartPointLine.default_color = Color(0, 256, 0)
		requestStartPointLine.width = 10
		requestStartPointLine.begin_cap_mode = requestStartPointLine.LINE_CAP_ROUND
		requestStartPointLine.end_cap_mode = requestStartPointLine.LINE_CAP_ROUND
		add_child(requestStartPointLine)
	else:
		remove_child(requestStartPointLine)
		requestStartPointLine = null
		requestPoint2 = Vector2(x - (int(x) % 5), REQUEST_HEIGHT)
		requestLine = Line2D.new()
		requestLine.add_point(requestPoint1)
		requestLine.add_point(requestPoint2)
		requestLine.default_color = Color(0, 256, 0)
		requestLine.width = 10
		requestLine.begin_cap_mode = requestLine.LINE_CAP_ROUND
		requestLine.end_cap_mode = requestLine.LINE_CAP_ROUND
		add_child(requestLine)

func submitRequest():
	if requestLine == null:
		return
	var requestTime1 = (requestPoint1.x / OBLIGATION_SCALE) + MainData.currTime
	var requestTime2 = (requestPoint2.x / OBLIGATION_SCALE) + MainData.currTime
	var request = Obligation.obligation.new(min(requestTime1, requestTime2), max(requestTime1, requestTime2))
	var result = schedule.requestTime(request, character.maxRequest())
	
func _process(delta):
	get_node("name").rect_position.x = get_parent().get_parent().scroll_horizontal
	
	
	