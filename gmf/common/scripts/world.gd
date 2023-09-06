extends Node

var server: Node
var client: Node

var players: Node2D
var enemies: Node2D
var npcs: Node2D


func init(world: Node2D, is_server = true) -> bool:
	var entities = Node2D.new()
	entities.name = "Entities"

	players = Node2D.new()
	players.name = "Players"
	entities.add_child(players)

	enemies = Node2D.new()
	enemies.name = "Enemies"
	entities.add_child(enemies)

	npcs = Node2D.new()
	npcs.name = "NPCs"
	entities.add_child(npcs)

	world.add_child(entities)

	if is_server:
		server = load("res://gmf/server/scripts/world.gd").new()
		server.name = "Server"
		add_child(server)
	else:
		client = load("res://gmf/client/scripts/world.gd").new()
		client.name = "Client"
		add_child(client)

	return true