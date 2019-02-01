extends Node

export(PackedScene) var location_node

const MapGen = preload("res://src/script/world/map.gd")

const CELL_RADIUS = 40
const WORLD_RADIUS = 12


func _ready():
	randomize()
	var map = MapGen.new(CELL_RADIUS, WORLD_RADIUS, location_node)
	add_child(map)
	map.createLocations()
	map.linkLocations()
	map.shiftLocations()
	map.alterLinks()
	map.placeEvents()
	
	map.finalizeLocations()