extends Node


func _ready():
	$SelectRunMode/VBoxContainer/RunAsServerButton.pressed.connect(_on_run_as_server_pressed)
	$SelectRunMode/VBoxContainer/RunAsClientButton.pressed.connect(_on_run_as_client_pressed)


func _on_run_as_server_pressed():
	Gmf.logger.info("Running as server")
	$SelectRunMode.queue_free()

	if not Gmf.init_server():
		Gmf.logger.err("Could not initialize the server, quitting")
		get_tree().quit()
		return

	var world = load("res://example/scenes/world/World.tscn").instantiate()
	world.name = "World"
	self.add_child(world)

	if not Gmf.init_world(world, true):
		Gmf.logger.err("Could not initialize the Server's world, quitting")
		get_tree().quit()
		return

	if not Gmf.server.start():
		Gmf.logger.error("Failed to start server, quitting")
		get_tree().quit()
		return


func _on_run_as_client_pressed():
	Gmf.logger.info("Running as client")
	$SelectRunMode.queue_free()

	if not Gmf.init_client():
		Gmf.logger.err("Could not initialize the client, quitting")
		get_tree().quit()
		return

	var world = load("res://example/scenes/world/World.tscn").instantiate()
	world.name = "World"
	world.set_client_mode()
	self.add_child(world)

	if not Gmf.init_world(world, false):
		Gmf.logger.err("Could not initialize the client's world, quitting")
		get_tree().quit()
		return
