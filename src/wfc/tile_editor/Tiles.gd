extends Panel

func _ready():
	pass 

func _input(event):
	if (event.is_action_released("left_click")):
		# Dont really know the difference between
		# event.position and get_global_mouse_position()
		# in this case
				
		if (
			event.position.x > rect_global_position.x &&
			event.position.x < rect_global_position.x + rect_size.x &&
			event.position.y > rect_global_position.y &&
			event.position.y < rect_global_position.y + rect_size.y
		):
#			print(event.position - rect_global_position)
			if (get_parent().get_parent().has_method("paint")):
				get_parent().get_parent().paint(event.position - rect_global_position, rect_global_position)
