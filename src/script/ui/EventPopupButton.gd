extends Button

var eventMaster
var end = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	print(SkillLoader)#pass


func _on_Button_pressed():
	if !end:
		eventMaster.processChoice(text)
	else:
		eventMaster.destroySelf()
