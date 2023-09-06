extends Node


func _ready():
	Gmf.signals.server.player_logged_in.connect(_on_player_logged_in)


func _on_player_logged_in(id: int, username: String):
	Gmf.logger.info("Adding player=[%s] with id=[%d]" % [username, id])

	var player = Gmf.player_scene.instantiate()
	player.name = username
	player.username = username
	player.peer_id = id
	$"../".players.add_child(player)

	Gmf.rpcs.player.add_player.rpc_id(id, id, username, player.position)
