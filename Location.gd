extends Node2D

var directLinkedNodes = []
var softLinkedNodes = []

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Visual.color = Color(randf(),randf(),randf())

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
