extends Node2D

export (PackedScene) var arrowType
var arrows = []

const SPEED = 400
const TIME_HOUR_THRESHOLD = 10
const TIME_SCALE = 100

var camera

var travelTimeAccumulator = 0
var mainData

# Location
var currentLocation
var currentTarget = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Icon/AnimationPlayer.play("Bounce")
	camera = get_tree().get_root().get_node("Main/Camera2D")
	mainData = get_tree().get_root().get_node("Main").get_node("MainData")
	
func _process(delta):
	if(currentTarget != null):
		if !arrows.empty():
			for arrow in arrows:
				remove_child(arrow)
			arrows = []
		var distance = SPEED * delta
		var direction = currentTarget.position - position
		if(direction.length() < SPEED/100):
			currentLocation = currentTarget
			currentTarget = null
			createArrows()
			travelTimeAccumulator = 0
		else:
			position += direction.normalized() * distance
			camera.position += direction.normalized() * distance
			travelTimeAccumulator += delta * TIME_SCALE
			print(travelTimeAccumulator)
			if(travelTimeAccumulator > TIME_HOUR_THRESHOLD):
				mainData.addTime(1)
				travelTimeAccumulator -= TIME_HOUR_THRESHOLD
	

func createArrows():
	for target in currentLocation.directLinkedNodes:
		createArrow(target)
		
func createArrow(target):
	var arrow = arrowType.instance()
	arrow.setup(currentLocation, target)
	self.add_child(arrow)
	arrows.append(arrow)
	
func moveTo(target):
	if currentTarget == null:
		currentTarget = target