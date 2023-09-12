extends GMFCharacterBody2D

var current_animation: String = "Idle"
var current_facing: String = "Down"


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

	state_changed.connect(_on_state_changed)


func _physics_process(delta):
	super(delta)

	if multiplayer.is_server():
		return

	if velocity.length() > 0:
		var direction = velocity.normalized()

		if direction.x > 0.5 and direction.y < 0.5 and direction.y > -0.5:
			current_facing = "Right"
		elif direction.x < -0.5 and direction.y < 0.5 and direction.y > -0.5:
			current_facing = "Left"
		elif direction.y > 0.5 and direction.x < 0.5 and direction.x > -0.5:
			current_facing = "Down"
		elif direction.y < -0.5 and direction.x < 0.5 and direction.x > -0.5:
			current_facing = "Up"

	$"Sprites/Character".play("%s_%s" % [current_animation, current_facing])


func _on_state_changed(new_state: String):
	Gmf.logger.info("Player's new state=[%s]" % new_state)
	current_animation = new_state
