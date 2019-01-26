extends Node2D

const EventLoader = preload("res://src/script/world/EventLoader.gd")

func _ready():
	EventLoader.loadEvents()
