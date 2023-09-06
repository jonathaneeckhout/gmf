extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Gmf.signals.server.player_logged_in.connect(_on_player_logged_in)


func _on_player_logged_in(id: int, username: String):
	Gmf.logger.info("Adding player=[%s] with id=[%d]" % [username, id])
