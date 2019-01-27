extends Control

var event
onready var head = get_node("MarginContainer/Panel/Header")
onready var body = get_node("MarginContainer/Panel/BodyText")
onready var buttonContainer = get_node("MarginContainer/Panel/HBoxContainer")
export (PackedScene) var buttonPrototype

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	print(head)
	print(body)
	print(head)
	head.text = event.name
	body.text = event.description
	for option in event.options:
		var btn = buttonPrototype.instance()
		btn.text = option
		#btn.eventMaster = self

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func setEvent(locationEvent):
	event = locationEvent
	