extends Node

export(PackedScene) var location_node

const MapGen = preload("res://src/script/world/map.gd")

const CELL_RADIUS = 400
const WORLD_RADIUS = 5


func _ready():
	randomize()
	var map = MapGen.new(CELL_RADIUS, WORLD_RADIUS, location_node)
	add_child(map)
	map.createLocations()
	map.linkLocations()
	map.shiftLocations()
	map.alterLinks()
	map.placeEvents()
	
	# Move player indicator to home
	map.getNode(0,0,0).position = Vector2(0,0)
	map.finalizeLocations()
	$PlayerIndicator.currentLocation = map.getNode(0,0,0)
	$PlayerIndicator.position = map.getNode(0,0,0).position
	$PlayerIndicator.createArrows()