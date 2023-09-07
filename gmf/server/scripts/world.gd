extends Node

var players_by_id = {}


func _ready():
	Gmf.signals.server.player_logged_in.connect(_on_player_logged_in)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)


func _on_player_logged_in(id: int, username: String):
	Gmf.logger.info("Adding player=[%s] with id=[%d]" % [username, id])

	var player = Gmf.player_scene.instantiate()
	player.name = username
	player.username = username
	player.peer_id = id
	$"../".players.add_child(player)

	# Add to this list for internal tracking
	players_by_id[id] = player

	Gmf.rpcs.player.add_player.rpc_id(id, id, username, player.position)


func _on_peer_disconnected(id):
	if id in players_by_id:
		var player = players_by_id[id]

		Gmf.logger.info("Removing player=[%s]" % player.name)

		# Disable physics which stops the sync
		player.set_physics_process(false)
		player.queue_free()

		players_by_id.erase(id)
