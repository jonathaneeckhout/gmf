extends GMFCharacterBody2D


func _input(event):
	# Don't handle input on server side
	if multiplayer.is_server():
		return

	if event.is_action_pressed("gmf_right_click"):
		move(get_global_mouse_position())


func _ready():
	super()

	if multiplayer.is_server():
		return

	Gmf.signals.client.player_state_changed.connect(_on_player_state_changed)


func _on_player_state_changed(new_state: String):
	Gmf.logger.info("Player's new state=[%s]" % new_state)
	match new_state:
		"Idle":
			$"Sprites/Character".play("idle_left")
		"Move":
			$"Sprites/Character".play("walk_left")
