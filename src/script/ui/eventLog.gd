extends ItemList



func _ready():
	add_item("GLHF", null, false)
	pass

func writeLogEntry(entry):
	if get_item_count() >= 7:
			remove_item(0)
	add_item(entry, null, false)
