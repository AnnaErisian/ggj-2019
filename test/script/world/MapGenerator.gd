extends Node

export(PackedScene) var location_node

const CELL_RADIUS = 40
const WORLD_RADIUS = 3/2 * CELL_RADIUS * 12

# Vector2 to Location
var hexgrid = {}
var locations = []

# @param: position Vector2
func addLoc(position):
	var new_loc = location_node.instance()
	add_child(new_loc)
	locations.append(new_loc)
	new_loc.position = position
	return new_loc

func cube_dist(a,b):
    return (abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)) / 2
	
func cubeToPixel(l):
	var x = CELL_RADIUS * (3.0/2 * l.x)
	var y = CELL_RADIUS * (sqrt(3)/2 * l.x  +  sqrt(3) * l.y)
	return Vector2(x, y)
    

func createLocations():
	for x in range(-WORLD_RADIUS, WORLD_RADIUS):
		for y in range(-WORLD_RADIUS, WORLD_RADIUS):
			var z = 0 - x - y
			var loc = Vector3(x,y,z)
			if cubeToPixel(loc).length() < WORLD_RADIUS:
				var newLoc = addLoc(cubeToPixel(loc))
				hexgrid[str(loc)] = newLoc
				

func linkLocations():
	for locString in hexgrid.keys():
		var regex = RegEx.new()
		print(locString)
		regex.compile("\\((?<x>-?\\d+\\.?\\d*), (?<y>-?\\d+\\.?\\d*), (?<z>-?\\d+\\.?\\d*)\\)")
		var matches = regex.search(locString)
		print(matches.get_string("x"))
		print(matches.get_string("y"))
		print(matches.get_string("z"))
		var loc = Vector3(int(matches.get_string("x")),int(matches.get_string("y")),int(matches.get_string("z")))
		var node = hexgrid[locString]
		var neighbors = []
		neighbors.append(Vector3(int(loc.x+1),int(loc.y-1),int(loc.z)))
		neighbors.append(Vector3(int(loc.x-1),int(loc.y+1),int(loc.z)))
		neighbors.append(Vector3(int(loc.x),int(loc.y+1),int(loc.z-1)))
		neighbors.append(Vector3(int(loc.x),int(loc.y-1),int(loc.z+1)))
		neighbors.append(Vector3(int(loc.x-1),int(loc.y),int(loc.z+1)))
		neighbors.append(Vector3(int(loc.x+1),int(loc.y),int(loc.z-1)))
		for n in neighbors:
			#print(n)	
			if hexgrid.has(str(n)):
				node.link(hexgrid[str(n)])

func shiftLocations():
	for loc in locations:
		loc.position.x += randf()*CELL_RADIUS - CELL_RADIUS/2
		loc.position.y += randf()*CELL_RADIUS - CELL_RADIUS/2
		loc.position = loc.position.normalized() * WORLD_RADIUS * pow(abs(loc.position.length() * 1.0 / WORLD_RADIUS), 1.5)


func _ready():
	randomize()
	createLocations()
	linkLocations()
	shiftLocations()
	#alterConnections()
	print(locations.size())