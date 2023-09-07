extends CharacterBody2D

class_name GMFCharacterBody2D

enum STATES { IDLE, MOVE }

const ARRIVAL_DISTANCE = 8
const SPEED = 300.0

@export var peer_id := 1:
	set(id):
		peer_id = id

var username: String = ""

var state = STATES.IDLE

var moving := false
var move_target := Vector2()

var server_synchronizer: Node2D


func _ready():
	server_synchronizer = load("res://gmf/common/scripts/serverSynchronizer.gd").new()
	server_synchronizer.name = "ServerSynchronizer"
	add_child(server_synchronizer)

	if multiplayer.is_server():
		Gmf.signals.server.player_moved.connect(_on_player_moved)


func _physics_process(delta):
	if multiplayer.is_server():
		fsm(delta)
		reset_inputs()

		move_and_slide()


func fsm(_delta):
	match state:
		STATES.IDLE:
			if moving:
				state = STATES.MOVE
			else:
				velocity = Vector2.ZERO
				state = STATES.IDLE
		STATES.MOVE:
			_handle_move()


func reset_inputs():
	moving = false


func move(pos: Vector2):
	_move.rpc_id(1, pos)


func _handle_move():
	if position.distance_to(move_target) > ARRIVAL_DISTANCE:
		velocity = position.direction_to(move_target) * SPEED
		state = STATES.MOVE
	else:
		velocity = Vector2.ZERO
		state = STATES.IDLE


func _on_player_moved(id: int, pos: Vector2):
	if id != peer_id:
		return

	moving = true
	move_target = pos


@rpc("call_remote", "any_peer", "reliable") func _move(pos: Vector2):
	if not is_multiplayer_authority():
		return

	var id = multiplayer.get_remote_sender_id()

	Gmf.signals.server.player_moved.emit(id, pos)
