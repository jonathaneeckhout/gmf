extends GMFEnemyBody2D

var current_animation: String = "Idle"
var current_facing: String = "Down"


func _ready():
	super()
	entity_type = Gmf.ENTITY_TYPE.ENEMY
	enemy_class = "Skeleton"

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
	current_animation = new_state
