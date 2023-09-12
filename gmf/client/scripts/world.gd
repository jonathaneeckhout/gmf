extends Node


func _ready():
	Gmf.signals.client.player_added.connect(_on_player_added)
	Gmf.signals.client.other_player_added.connect(_on_other_player_added)


func _on_player_added(id: int, username: String, pos: Vector2):
	var player = Gmf.player_scene.instantiate()
	player.name = username
	player.username = username
	player.enable_input = true
	player.peer_id = id
	player.position = pos
	$"../".players.add_child(player)


func _on_other_player_added(username: String, pos: Vector2):
	var player = Gmf.player_scene.instantiate()
	player.name = username
	player.username = username
	player.position = pos
	$"../".players.add_child(player)
