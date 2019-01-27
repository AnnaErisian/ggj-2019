extends Node2D

var directLinkedNodes = []
var softLinkedNodes = []
var event
var visited = false
	
var preparedPoly = false

var drawDebugPoints = false
var debugPoints = []

export (PackedScene) var eventPopupScene

onready var visual = get_node("Visual")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#$Visual.color = Color(randf(),randf(),randf())
	pass
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

const white = Color("#FFFFFF")
func _draw():
	if event.eventType != "wilderness" and visited:
		draw_circle(Vector2(0,0),20,white)
		draw_circle(Vector2(0,0),16,$Visual.color)
		print("ye")
	if drawDebugPoints:
		for n in debugPoints:
			draw_circle(n, 20, $Visual.color)

func setupPolygon():
	var lines = []
	var points = []
	var neighbors = getAllLinkedNodes()
	if(neighbors.size() < 6):
		var a = Node2D.new()
		var averageNodeDirection = Vector2(0,0)
		for n in neighbors:
			averageNodeDirection += n.position - position
		averageNodeDirection /= neighbors.size()
		a.position = position + averageNodeDirection*-1
		neighbors.append(a)
	neighbors.sort_custom(AngleSorter.new(position), "sort")
	for n in neighbors:
		#vector between, haldway point, slope of midline
		var vector_between = n.position - position
		var midpoint = position + vector_between/2
		var slope = vector_between.rotated(PI/2)
		lines.append([midpoint, midpoint+slope])
	for i in range(lines.size()):
		var j = (i+1)%lines.size()
		var p1 = lines[i]
		var p2 = lines[j]
		var point = getIntersect(p1,p2)
		points.append((Vector2(point[0],point[1]) - position))
	#detect strange crossings
	var changedSomething = true
	while changedSomething:
		changedSomething = false
		var vectors = []
		for i in range(points.size()):
			var j = (i+1)%points.size()
			var p1 = points[i]
			var p2 = points[j]
			vectors.append(p2-p1)
		for i in range(vectors.size()):
			var j = (i+1)%vectors.size()
			var v1 = vectors[i]
			var v2 = vectors[j]
			if v1.angle_to(v2) <= 0:
				changedSomething = true
				#drawDebugPoints = true
				#debugPoints = points.duplicate()
				var k = (i+2)%vectors.size()
				var early_cross_a = [points[i], points[i]+vectors[i]]
				var early_cross_b = [points[k], points[k]+vectors[k]]
				var new_point = getIntersect(early_cross_a, early_cross_b)
				new_point = (Vector2(new_point[0],new_point[1]))
				var point_to_remove_a = points[j]
				var point_to_remove_b = points[k]
				points[k] = new_point
				points.remove(j)
				break
	var avgdist = 0
	for i in range(points.size()):
		points[i] *= 0.5
		avgdist+= points[i].length()
	avgdist /= neighbors.size()+1
	for i in range(points.size()):
		if points[i].length() > avgdist:
			points[i] = points[i].normalized() * avgdist
		
	$Visual.polygon = points
	if points.size() == 6:
		return true
	else:
		#drawDebugPoints = true
		return false
			
func det2(a,b,c,d):
	var det = a*d-b*c
	return det
		
class AngleSorter:
	var origin
	func _init(pos):
		origin = pos
	
	func sort(a, b):
		var unit = Vector2(0,1)
		var vector_a = a.position - origin
		var vector_b = b.position - origin
		if unit.angle_to(vector_a) < unit.angle_to(vector_b):
			return true
		return false

func getIntersect(p1,p2):
	var x1 = p1[0].x
	var y1 = p1[0].y
	var x2 = p1[1].x
	var y2 = p1[1].y
	var x3 = p2[0].x
	var y3 = p2[0].y
	var x4 = p2[1].x
	var y4 = p2[1].y
	#https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_points_on_each_line
	var d = det2(det2(x1,1,x2,1),det2(y1,1,y2,1),det2(x3,1,x4,1),det2(y3,1,y4,1))
	if(d == 0):
		return [(x1+x2+x3+x4)/4,(y1+y2+y3+y4)/4]
	var point_x = det2(det2(x1,y1,x2,y2),det2(x1,1,x2,1),det2(x3,y3,x4,y4),det2(x3,1,x4,1)) / d
	var point_y = det2(det2(x1,y1,x2,y2),det2(y1,1,y2,1),det2(x3,y3,x4,y4),det2(y3,1,y4,1)) / d
	return [point_x, point_y]

func getAllLinkedNodes():
	var a = []
	for x in directLinkedNodes:
		a.append(x)
	for x in softLinkedNodes:
		a.append(x)
	return a

func link(other):
	#print(directLinkedNodes.size())
	if !directLinkedNodes.has(other):
		directLinkedNodes.append(other)
		other.directLinkedNodes.append(self)

func unlink(other):
	if directLinkedNodes.has(other):
		directLinkedNodes.erase(other)
		other.directLinkedNodes.erase(self)

func destroySelf():
	for n in directLinkedNodes:
		n.directLinkedNodes.erase(self)
	for n in softLinkedNodes:
		n.softLinkedNodes.erase(self)
	get_parent().remove_child(self)

func triggerEvent():
	var hud = get_node("/root/Main/Camera2D/CanvasLayer/WorldHUD")
	var popup = eventPopupScene.instance()
	popup.setEvent(event)
	hud.add_child(popup)
	visited = true
	update()
	
func setLocationEvent(e):
	event = e
	$Visual.color = e.eventColor
	#$Visual.color = Color(randf(),randf(),randf())