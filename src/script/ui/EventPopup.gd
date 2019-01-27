extends Control

var event
onready var head = get_node("MarginContainer/Panel/Header")
onready var body = get_node("MarginContainer/Panel/BodyText")
onready var buttonContainer = get_node("MarginContainer/Panel/HBoxContainer")
onready var eventLoader = load("res://src/script/world/LocationEventLoader.gd").eventLoader.new()
export (PackedScene) var buttonPrototype

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	head.text = event.name
	body.text = event.description
	for option in event.options:
		var btn = buttonPrototype.instance()
		btn.text = option
		btn.eventMaster = self
		buttonContainer.add_child(btn)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func setEvent(locationEvent):
	event = locationEvent

func processChoice(optionKey):
	print( MainData.party.skillTotals())
	var results = event.selectOption(optionKey, MainData.party.skillTotals())
	event.applyResults(results)
	if(results.has("event")):
		eventLoader.loadEvents()
		var hud = get_node("/root/Main/Camera2D/CanvasLayer/WorldHUD")
		var popup = load("res://src/scene/ui/EventPopup.tscn").instance()
		popup.setEvent(eventLoader.events[results["event"]])
		hud.add_child(popup)
		hud.remove_child(self)
	else:
		for child in buttonContainer.get_children():
			buttonContainer.remove_child(child)
		head.text = ""
		body.text = results['text']
		var btn = buttonPrototype.instance()
		btn.text = "Continue"
		btn.end = true
		btn.eventMaster = self
		buttonContainer.add_child(btn)

func destroySelf():
	get_parent().remove_child(self)
	pass








