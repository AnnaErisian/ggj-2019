extends Area2D

func _input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.is_pressed() \
	and ! Input.is_key_pressed(KEY_SPACE):
        self.on_click()

func on_click():
    get_node("../..").notifyPlayerToMove()