extends Node

export(PackedScene) var location_node

const WORLD_RADIUS = 300
const WORLD_DIAMETER = WORLD_RADIUS*2
const WORLD_NODE_COUNT = 150

var locations = []

# @param: position Vector2
func addLoc(position):
	var new_loc = location_node.instance()
	add_child(new_loc)
	locations.append(new_loc)
	new_loc.position = position
	new_loc.position += Vector2(WORLD_RADIUS*1.1,WORLD_RADIUS*1.1)
	return new_loc

func createLocations():
	for i in range(WORLD_NODE_COUNT):
		addLoc(Vector2(0, WORLD_RADIUS*pow(randf(),1.0)).rotated(2*PI*randf()))

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
	pass

func _ready():
	createLocations()
	relaxLocations(4)
	connectLocations()
	#alterConnections()

func delaunayTriangulate():
	var unaddedLocations = locations.duplicate()
	var fakeNodes = createFakeExernalNodes()
	var triDag = DelaunayTriNode(a,b,c)
	for location in unaddedLocations:
		tri = triDag.findContaining(location)

func createFakeExernalNodes():
	var a = addLoc(Vector2(0,WORLD_RADIUS*4))
	var b = addLoc(Vector2(WORLD_RADIUS*2,WORLD_RADIUS*-2))
	var c = addLoc(Vector2(WORLD_RADIUS*-2,WORLD_RADIUS*-2))
	a.link(b)
	b.link(c)
	c.link(a)

class DelaunayTriNode:
	var nodes = []
	var children = []
	var old = false
	
	func _init(a,b,c):
		nodes = [a,b,c]

# @param: all Vector2
func sameSide(p1,p2, a,b):
	var cp1 = (b-a).cross(p1-a)
	var cp2 = (b-a).cross(p2-a)
	return cp1.dot(cp2) >= 0

# @param: all Vector2
func pointInTriangle(p, a,b,c):
	return sameSide(p,a, b,c) and sameSide(p,b, a,c) and sameSide(p,c, a,b)

# @param: all Vector2
func pointsCounterclockwise(a,b,c):
	return (b.x-a.x)*(c.y-a.y)-(c.x-a.x)*(b.y-a.y)>0

func validEdge(triangle,point):
	adjOpTri = adjacentOppositeTriange(triangle,point)
	if inCircle(triangle[0],triangle[1],triangle[2],point):
		flipAndLegalize(triangle,adjOpTri,point)

func adjacentOppositeTriange(triangle,point):
	var tri = triangle.duplicate()
	tri.remove(point)
	var a = point
	var b = tri[0]
	var c = tri[1]
	#find point linked to both that is not a
	for p in b.directLinkedNodes:
		if p != a and c.directLinkedNodes.has(p):
			return [b,p,c]

func flipAndLegalize(triangle,adjOpTri,point):
	#triangle = abc
	#aotri = bcd
	#point = a
	var a = point
	#clone so we leave the original arrays alone
	var tri = triangle.duplicate()
	var aotri = adjOpTri.dupliate()
	#remove new point from tri, leaving two currently connected points
	tri.remove(tri.find(point))
	var b = tri[0]
	var c = tri[1]
	#remove those connected points from the other triangle, leaving the far point
	aotri.remove(b)
	aotri.remove(c)
	var d = aotri[0]
	#flip the edge
	b.unlink(c)
	a.link(d)
	validEdge([a,b,d],a)
	validEdge([a,c,d],a)

# @param: all Vector2
func inCircle(a,b,c,d):
	return det4(a.x,a.y,(a.x*a.x+a.y*a.y),1, b.x,b.y,(b.x*b.x+b.y*b.y),1, c.x,c.y,(c.x*c.x+c.y*c.y),1, d.x,d.y,(d.x*d.x+d.y*d.y),1) > 0

func det4(a,b,c,d, e,f,g,h, i,j,k,l, m,n,o,p):
	return a*det3(f,g,h,j,k,l,n,o,p)-b*det3(e,g,h,i,k,l,m,o,p)+c*det3(e,f,h,i,j,l,m,n,p)-d*det3(e,f,g,i,j,k,m,n,o)

func det3(a,b,c,d,e,f,g,h,i):
	return a*det2(e,f,h,i)-b*det2(d,f,g,i)+c*det2(d,e,g,h)

func det2(a,b,c,d):
	return a*d-b*c