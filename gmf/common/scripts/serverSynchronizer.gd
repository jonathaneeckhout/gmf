extends Node2D

const INTERPOLATION_OFFSET = 0.1
const INTERPOLATION_INDEX = 2

var parent: Node2D

var last_sync_timestamp = 0.0
var server_syncs_buffer = []

var state_buffer = []


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = $"../"


func _physics_process(_delta):
	if is_multiplayer_authority():
		var timestamp = Time.get_unix_time_from_system()
		sync.rpc_id(parent.peer_id, timestamp, parent.position)
	else:
		calculate_position()
		check_if_state_updated()


func calculate_position():
	var render_time = Gmf.client.clock - INTERPOLATION_OFFSET

	while (
		server_syncs_buffer.size() > 2
		and render_time > server_syncs_buffer[INTERPOLATION_INDEX]["timestamp"]
	):
		server_syncs_buffer.remove_at(0)

	if server_syncs_buffer.size() > INTERPOLATION_INDEX:
		parent.position = interpolate(render_time)
	elif (
		server_syncs_buffer.size() > INTERPOLATION_INDEX - 1
		and render_time > server_syncs_buffer[INTERPOLATION_INDEX - 1]["timestamp"]
	):
		parent.position = extrapolate(render_time)


func interpolate(render_time):
	var interpolation_factor = (
		float(render_time - server_syncs_buffer[INTERPOLATION_INDEX - 1]["timestamp"])
		/ float(
			(
				server_syncs_buffer[INTERPOLATION_INDEX]["timestamp"]
				- server_syncs_buffer[INTERPOLATION_INDEX - 1]["timestamp"]
			)
		)
	)

	return server_syncs_buffer[INTERPOLATION_INDEX - 1]["position"].lerp(
		server_syncs_buffer[INTERPOLATION_INDEX]["position"], interpolation_factor
	)


func extrapolate(render_time):
	var extrapolation_factor = (
		float(render_time - server_syncs_buffer[INTERPOLATION_INDEX - 2]["timestamp"])
		/ float(
			(
				server_syncs_buffer[INTERPOLATION_INDEX - 1]["timestamp"]
				- server_syncs_buffer[INTERPOLATION_INDEX - 2]["timestamp"]
			)
		)
	)

	return server_syncs_buffer[INTERPOLATION_INDEX - 2]["position"].lerp(
		server_syncs_buffer[INTERPOLATION_INDEX - 1]["position"], extrapolation_factor
	)


func send_new_state(new_state: String):
	var timestamp = Time.get_unix_time_from_system()
	state_changed.rpc_id(parent.peer_id, timestamp, new_state)


func check_if_state_updated():
	for i in range(state_buffer.size() - 1, -1, -1):
		if state_buffer[i]["timestamp"] <= Gmf.client.clock:
			parent.state = state_buffer[i]["new_state"]
			Gmf.signals.client.player_state_changed.emit(parent.state)
			state_buffer.remove_at(i)
			return true


@rpc("call_remote", "authority", "unreliable") func sync(timestamp: float, pos: Vector2):
	# Ignore older syncs
	if timestamp < last_sync_timestamp:
		return

	last_sync_timestamp = timestamp
	server_syncs_buffer.append({"timestamp": timestamp, "position": pos})


@rpc("call_remote", "any_peer", "reliable") func move(pos: Vector2):
	if not is_multiplayer_authority():
		return

	var id = multiplayer.get_remote_sender_id()

	Gmf.signals.server.player_moved.emit(id, pos)


@rpc("call_remote", "authority", "reliable") func state_changed(timestamp: float, new_state: String):
	state_buffer.append({"timestamp": timestamp, "new_state": new_state})
