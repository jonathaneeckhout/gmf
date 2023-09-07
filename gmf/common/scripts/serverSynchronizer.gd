extends Node2D

const INTERPOLATION_OFFSET = 0.1
const INTERPOLATION_INDEX = 2

var parent: Node2D

var last_sync_timestamp = 0.0
var server_syncs_buffer = []


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = $"../"


func _physics_process(_delta):
	if multiplayer.is_server():
		var timestamp = Time.get_unix_time_from_system()
		sync.rpc_id(parent.peer_id, timestamp, parent.position)
	else:
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


@rpc("call_remote", "authority", "unreliable") func sync(timestamp: float, pos: Vector2):
	# Ignore older syncs
	if timestamp < last_sync_timestamp:
		return

	last_sync_timestamp = timestamp
	server_syncs_buffer.append({"timestamp": timestamp, "position": pos})
