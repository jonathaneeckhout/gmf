extends Node

@rpc("call_remote", "authority", "reliable")
func add_player(id: int, username: String, pos: Vector2):
	Gmf.signals.client.player_added.emit(id, username, pos)
