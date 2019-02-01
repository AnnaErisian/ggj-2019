extends Node

export(PackedScene) var location_node

const WORLD_RADIUS = 400
const WORLD_DIAMETER = WORLD_RADIUS*2
const WORLD_NODE_COUNT = 50

var locations = []
var unprocessedLocations = []
var hexgrid = {}

var fakeTri
var triangulation

# @param: position Vector2
func addLoc(position, locname):
	var new_loc = location_node.instance()
	add_child(new_loc)
	locations.append(new_loc)
	unprocessedLocations.append(new_loc)
	new_loc.position = position
	new_loc.position += Vector2(WORLD_RADIUS*3.1,WORLD_RADIUS*3.1)
	new_loc.id = locname
	return new_loc

func createLocations():
	for i in range(WORLD_NODE_COUNT):
		addLoc(Vector2(0, WORLD_RADIUS*pow(randf(),1.0)).rotated(2*PI*randf()), str(i))
#	addLoc(Vector2(WORLD_RADIUS, 0), "A")
#	addLoc(Vector2(-0.5*WORLD_RADIUS, WORLD_RADIUS), "C")
#	addLoc(Vector2(-0.5*WORLD_RADIUS, -1*WORLD_RADIUS), "D")
#	addLoc(Vector2(-100, -250), "B")
#	addLoc(Vector2(0, 180), "E")

func relaxLocations(iterations):
	for iter in range(iterations):
		for loc in locations:
			var closest = loc
			var min_dist = WORLD_DIAMETER
			for other in locations:
				var dist = other.position.distance_to(loc.position)
				if(dist != 0 and min_dist > dist):
					closest = other
					min_dist = dist
			loc.position += (loc.position - closest.position).normalized()*3

func connectLocations():
	var triangulation = BowyerWatson()
	for triangle in triangulation:
		triangle.linkNodes()

func _ready():
	randomize()
	createLocations()
	relaxLocations(4)
	
	var fakeNodes = createFakeExternalNodes()
	fakeTri = Triangle.new(fakeNodes[0], fakeNodes[1], fakeNodes[2])
	triangulation = [fakeTri]
#	connectLocations()
	placeEvents()
	for l in locations:
		l.setColor(Color("#FFFFFF"))

var counter = 0
var delay = 10

func _process(delta):
	counter += 1
	if counter > delay:
		counter -= delay
		if(unprocessedLocations.size()>0):
			var nextLoc = unprocessedLocations.pop_back()
			BWiteration(triangulation, nextLoc)
			nextLoc.setColor(Color("#FF0000"))


func placeEvents():
	var events = LocationEventLoader.events
	var home = locations[randi()%locations.size()]
	var immediateEvents = []
	var uniqueEvents = []
	var wildernessEvents = []
	for event in events:
		if(event == "Home"):
			home.setLocationEvent(events[event])
			home.visited = true
		else:
			if events[event].eventImmediate:
				immediateEvents.append(events[event])
			elif(!events[event].internal):
				if events[event].eventType == "wilderness":
					wildernessEvents.append(events[event])
				else:
					uniqueEvents.append(events[event])
	#place immediate events
	var nearSpots = home.directLinkedNodes.duplicate()
	for loc in immediateEvents:
		nearSpots.pop_front().setLocationEvent(loc)
#	while uniqueEvents.size() > 0:
#		var potentialLoc = locations[randi()%locations.size()]
#		if(potentialLoc.event == null):
#			potentialLoc.setLocationEvent(uniqueEvents.pop_front())
	for loc in locations:
		if(loc.event == null):
			loc.setLocationEvent(wildernessEvents[randi()%wildernessEvents.size()])

class Triangle:
	var nodes = []
	
	func _init(a,b,c):
		
		if det3(a.position.x, a.position.y, 1, b.position.x, b.position.y, 1, c.position.x, c.position.y, 1) > 0 :
			nodes = [a,b,c]
		else: 
			nodes = [b,a,c]
	
	func contains(point):
		var p = point.position
		var a = nodes[0].position
		var b = nodes[1].position
		var c = nodes[2].position
		var s1 = side(p,a,b)
		var s2 = side(p,b,c)
		var s3 = side(p,c,a)
		var has_neg = s1<0 or s2<0 or s3<0
		var has_pos = s1>0 or s2>0 or s3>0
		return !(has_neg and has_pos)
	
	func sharesNode(otherTri):
		return nodes.has(otherTri.nodes[0]) ||  nodes.has(otherTri.nodes[1]) || nodes.has(otherTri.nodes[2])
	
	func equalNodes(a,b,c):
		var x = nodes.has(a) and nodes.has(b) and nodes.has(c)
		#print(x)
		return x
	
	func side(p,a,b):
		return (p.x-b.x)*(a.y-b.y) - (a.x-b.x)*(p.y-b.y)
	
	func printMe():
		var s = "Tri: %s" % [nodes]
	
	func inCircumcircle(otherloc):
		return _inCircle(nodes[0].position,nodes[1].position,nodes[2].position,otherloc.position)
	
	func linkNodes():
		nodes[0].link(nodes[1])
		nodes[1].link(nodes[2])
		nodes[2].link(nodes[0])
	
	func edges():
		return [[nodes[0],nodes[1]],[nodes[1],nodes[2]],[nodes[2],nodes[0]]]
	
	func _inCircle(a,b,c,d):
		#print("InCirlce(%s, %s, %s, %s)" % [a,b,c,d])
		var det = det4(a.x,a.y,(a.x*a.x+a.y*a.y),1, b.x,b.y,(b.x*b.x+b.y*b.y),1, c.x,c.y,(c.x*c.x+c.y*c.y),1, d.x,d.y,(d.x*d.x+d.y*d.y),1)
		return det > 0
	
	func det4(a,b,c,d, e,f,g,h, i,j,k,l, m,n,o,p):
		var det = a*det3(f,g,h,j,k,l,n,o,p)-b*det3(e,g,h,i,k,l,m,o,p)+c*det3(e,f,h,i,j,l,m,n,p)-d*det3(e,f,g,i,j,k,m,n,o)
		#print("Determinant4: " + str(det))
		return det
	
	func det3(a,b,c,d,e,f,g,h,i):
		return a*det2(e,f,h,i)-b*det2(d,f,g,i)+c*det2(d,e,g,h)
	
	func det2(a,b,c,d):
		return a*d-b*c

#func BowyerWatson():
#	for triangle in triangulation: #done inserting points, now clean up
#		if triangle.sharesNode(fakeTri):
#			triangulation.erase(triangle)
#	return triangulation

func BWiteration(triangulation, node):
	var badTriangles = []
	for triangle in triangulation: # first find all the triangles that are no longer valid due to the insertion
		if triangle.inCircumcircle(node): #point is inside circumcircle of triangle
			badTriangles.append(triangle)
	var polygon = []
	for triangle in badTriangles: # find the boundary of the polygonal hole
		for edge in triangle.edges():
			if polygonContainsEdge(polygon, edge):# edge is not shared by any other triangles in badTriangles
				polygon.erase(edge)
				polygon.erase([edge[1],edge[0]])
			else:
				polygon.append(edge)
	print("BT size: %s, P size: %s" % [badTriangles.size(), polygon.size()])
	for triangle in badTriangles: #remove them from the data structure
		triangulation.erase(triangle)
		unlinkTriangle(triangle)
	for edge in polygon: #re-triangulate the polygonal hole
		var newTri = Triangle.new(edge[0],edge[1],node) #form a triangle from edge to point
		triangulation.append(newTri)
		linkTriangle(newTri)

func unlinkTriangle(t):
	t.nodes[0].unlink(t.nodes[1])
	t.nodes[1].unlink(t.nodes[2])
	t.nodes[2].unlink(t.nodes[0])
	t.nodes[0].updateAll()
	t.nodes[1].updateAll()
	t.nodes[2].updateAll()
	
func linkTriangle(t):
	t.nodes[0].link(t.nodes[1])
	t.nodes[1].link(t.nodes[2])
	t.nodes[2].link(t.nodes[0])
	t.nodes[0].updateAll()
	t.nodes[1].updateAll()
	t.nodes[2].updateAll()

func polygonContainsEdge(poly, e):
	for ed in poly:
		if(ed[0]==e[0] && ed[1] == e[1]) or (ed[0]==e[1] && ed[1] == e[0]):
			return true
	return false

func createFakeExternalNodes():
	var maxCoord = 0
	for l in locations :
		if(abs(l.position.x) > maxCoord):
			maxCoord = abs(l.position.x)
			
		if(abs(l.position.y) > maxCoord):
			maxCoord = abs(l.position.y)
	var a = addLoc(Vector2(maxCoord*3,0), "Right Dummy")
	var b = addLoc(Vector2(0,maxCoord*3), "Bottom Dummy")
	var c = addLoc(Vector2(maxCoord*-3,maxCoord*-3), "Top Left Dummy")
	return [a,b,c]