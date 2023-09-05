extends Node


func _ready():
	$SelectRunMode/VBoxContainer/RunAsServerButton.pressed.connect(_on_run_as_server_pressed)
	$SelectRunMode/VBoxContainer/RunAsClientButton.pressed.connect(_on_run_as_client_pressed)


func _on_run_as_server_pressed():
	Gmf.logger.info("Running as server")
	$SelectRunMode.queue_free()

	var server = load("res://gmf/server/scenes/server/Server.tscn").instantiate()
	self.add_child(server)


func _on_run_as_client_pressed():
	Gmf.logger.info("Running as client")
	$SelectRunMode.queue_free()

	var client = load("res://gmf/client/scenes/client/Client.tscn").instantiate()
	self.add_child(client)

	var client_world = load("res://example/client/scenes/clientworld/ClientWorld.tscn").instantiate()
	self.add_child(client_world)
