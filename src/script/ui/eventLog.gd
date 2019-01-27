extends ItemList

var maxLength = 7


func _ready():
	add_item("GLHF", null, false)
	pass

func write(entry):
	if get_item_count() >= maxLength:
			remove_item(0)
	add_item(entry, null, false)
	print("debug - " + entry)
