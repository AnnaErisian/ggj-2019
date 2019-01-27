extends Node2D

var directLinkedNodes = []
var softLinkedNodes = []
var event

export (PackedScene) var eventPopupScene

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#$Visual.color = Color(randf(),randf(),randf())
	pass
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _draw():
	#print(str(directLinkedNodes.size()))
	for n in directLinkedNodes:
		draw_line(Vector2(0,0),n.position - position,Color(1,1,1))
	
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
	
func setLocationEvent(e):
	event = e
	$Visual.color = e.eventColor
	