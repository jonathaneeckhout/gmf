extends Node

var backend: Node


# Called when the node enters the scene tree for the first time.
func _ready():
	match Gmf.global.env_server_database_backend:
		"json":
			Gmf.logger.info("Loading json database backend")
			backend = load("res://gmf/server/scripts/database/backends/json_backend.gd").new()
			backend.name = "Backend"
			add_child(backend)


func create_account(username: String, password: String) -> bool:
	if username == "" or password == "":
		Gmf.logger.info("Invalid username or password")
		return false

	return true
