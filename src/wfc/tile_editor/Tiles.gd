extends Panel

func _ready():
	pass 

func _input(event):
	if (event.is_action("left_click")):
		print(event.position)
		print(self.visible)
