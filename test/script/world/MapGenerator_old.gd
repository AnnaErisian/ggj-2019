extends Node

export(PackedScene) var location_node

const WORLD_RADIUS = 40
const WORLD_DIAMETER = WORLD_RADIUS*2
const WORLD_NODE_COUNT = 5

var locations = []

var unaddedLocations = []
var fakeNodes = []
var triDag = []

# @param: position Vector2
func addLoc(position):
	var new_loc = location_node.instance()
	add_child(new_loc)
	locations.append(new_loc)
	new_loc.position = position
	new_loc.position += Vector2(WORLD_RADIUS*3.1,WORLD_RADIUS*3.1)
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
	#DOESN'T WORK, CAN'T FIGURE OUT WHY
	delaunayTriangulate()

func _ready():
	randomize()
	createLocations()
	relaxLocations(4)
	connectLocations()
	relaxLocationsAngular(1)
	#alterConnections()


class DelaunayTriNode:
	var nodes = []
	var children = []
	var old = false
	
	func _init(a,b,c):
		#if points ccw
		if (b.position.x-a.position.x)*(c.position.y-a.position.y)-(c.position.x-a.position.x)*(b.position.y-a.position.y)>0 :
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
	
	func findContaining(point):
		var x = findContaining_internal(point)
		#print("FC" + str(x.nodes))
		return x
	
	func findContaining_internal(point):
		var candidates = []
		for child in children:
			if(child.contains(point)):
				candidates.append(child)
		if(candidates.empty()):
			if(old):
				return false
			else:
				return self
		for child in candidates:
			var rv = child.findContaining_internal(point)
			if typeof(rv) == TYPE_OBJECT:
				return rv
		return false
			
	
	func findLiveTri(a,b,c):
		var x = findLiveTri_internal(a,b,c)
		#print(x)
		return x


	func findLiveTri_internal(a,b,c):
		if equalNodes(a,b,c) and !old:
			return self
		for child in children:
			var r = child.findLiveTri_internal(a,b,c)
			if r:
				return r
			else:
				pass#print("A")
		return false
	
	func equalNodes(a,b,c):
		if false:
			print("eqnodes")
			print(nodes[0])
			print(nodes[1])
			print(nodes[2])
			print(a)
			print(b)
			print(c)
		var x = nodes.has(a) and nodes.has(b) and nodes.has(c)
		#print(x)
		return x
	
	func side(p,a,b):
		return (p.x-b.x)*(a.y-b.y) - (a.x-b.x)*(p.y-b.y)
	
	func printMe(n):
		var s = "Tri: %s, %s" % [nodes, old]
		for i in range(n):
			s = "  " + s
		print(s)
		for child in children:
			child.printMe(n+1)

func delaunayTriangulate():
	unaddedLocations = locations.duplicate()
	fakeNodes = createFakeExernalNodes()
	triDag = DelaunayTriNode.new(fakeNodes[0],fakeNodes[1],fakeNodes[2])
	while(unaddedLocations.size() > 0):
		var index = randi()%unaddedLocations.size()
		var location = unaddedLocations[index]
		unaddedLocations.remove(index)
		#print(location.position)
		#We are assuming the point never lands on an edge
		var parent = triDag.findContaining(location)
		#print(parent.nodes[0].position)
		parent.old = true
		var t1 = DelaunayTriNode.new(parent.nodes[0], parent.nodes[1], location)
		var t2 = DelaunayTriNode.new(parent.nodes[1], parent.nodes[2], location)
		var t3 = DelaunayTriNode.new(parent.nodes[2], parent.nodes[0], location)
		parent.children.append(t1)
		parent.children.append(t2)
		parent.children.append(t3)
		location.link(parent.nodes[0])
		location.link(parent.nodes[1])
		location.link(parent.nodes[2])
		validEdge(t1,location,triDag)
		validEdge(t2,location,triDag)
		validEdge(t3,location,triDag)
	for n in fakeNodes:
		n.destroySelf()
	#triDag.printMe(0)

func createFakeExernalNodes():
	var maxCoord = 0
	for l in locations :
		if(abs(l.position.x) > maxCoord):
			maxCoord = abs(l.position.x)
			
		if(abs(l.position.y) > maxCoord):
			maxCoord = abs(l.position.y)
	var a = addLoc(Vector2(maxCoord*3,0))
	var b = addLoc(Vector2(0,maxCoord*3))
	var c = addLoc(Vector2(maxCoord*-3,maxCoord*-3))
	a.link(b)
	b.link(c)
	c.link(a)
	return [a,b,c]

func validEdge(triangle,point,root):
	#print("validEdge")
	var adjOpTri = adjacentOppositeTriange(triangle,point,root)
	if adjOpTri:
		#print("A")
		if inCircle(adjOpTri.nodes[0].position,adjOpTri.nodes[1].position,adjOpTri.nodes[2].position,point.position):
			#print("B")
			flipAndLegalize(triangle,adjOpTri,point,root)

func adjacentOppositeTriange(triangle,point,root):
	#print("adjacentOppositeTriange")
	var tri = triangle.nodes.duplicate()
	tri.erase(point)
	var a = point
	var b = tri[0]
	var c = tri[1]
	#find point linked to both that is not a
	for p in b.directLinkedNodes:
		if p != a and c.directLinkedNodes.has(p):
			var hit = root.findLiveTri(p,b,c)
			#print(hit)
			return hit
	print("ILLEGAL")

func flipAndLegalize(triangle,adjOpTri,point,root):
	print("flipAndLegalize")
	#triangle = abc
	#aotri = bcd
	#point = a
	var a = point
	#clone so we leave the original arrays alone
	var tri = triangle.nodes.duplicate()
	var aotri = adjOpTri.nodes.duplicate()
	#remove new point from tri, leaving two currently connected points
	tri.erase(a)
	var b = tri[0]
	var c = tri[1]
	#remove those connected points from the other triangle, leaving the far point
	aotri.erase(b)
	aotri.erase(c)
	var d = aotri[0]
	#flip the edge
	b.unlink(c)
	a.link(d)
	var nta = DelaunayTriNode.new(a,b,d)
	var ntb = DelaunayTriNode.new(a,c,d)
	triangle.children.append(nta)
	triangle.children.append(ntb)
	triangle.old = true
	adjOpTri.children.append(nta)
	adjOpTri.children.append(ntb)
	adjOpTri.old = true
	validEdge(nta,a,root)
	validEdge(ntb,a,root)

# @param: all Vector2
func inCircle(a,b,c,d):
	#print("InCirlce(%s, %s, %s, %s)" % [a,b,c,d])
	var det = det4(a.x,a.y,(a.x*a.x+a.y*a.y),1, b.x,b.y,(b.x*b.x+b.y*b.y),1, c.x,c.y,(c.x*c.x+c.y*c.y),1, d.x,d.y,(d.x*d.x+d.y*d.y),1)
	return det > 0

func det4(a,b,c,d, e,f,g,h, i,j,k,l, m,n,o,p):
	var det = a*det3(f,g,h,j,k,l,n,o,p)-b*det3(e,g,h,i,k,l,m,o,p)+c*det3(e,f,h,i,j,l,m,n,p)-d*det3(e,f,g,i,j,k,m,n,o)
	#print("Determinant4: " + str(det))
	return det

func det3(a,b,c,d,e,f,g,h,i):
	var det = a*det2(e,f,h,i)-b*det2(d,f,g,i)+c*det2(d,e,g,h)
	#print("Determinant3: " + str(det))
	return det

func det2(a,b,c,d):
	var det = a*d-b*c
	#print("Determinant2 (%d %d %d %d): %d" % [a,b,c,d,det])
	return det