extends GMFCharacterBody2D


func _input(event):
	# Don't handle input on server side
	if multiplayer.is_server():
		return

	if event.is_action_pressed("gmf_right_click"):
		move(get_global_mouse_position())
