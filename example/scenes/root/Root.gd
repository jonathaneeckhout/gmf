extends Node


func _ready():
	$SelectRunMode/VBoxContainer/RunAsServerButton.pressed.connect(_on_run_as_server_pressed)
	$SelectRunMode/VBoxContainer/RunAsClientButton.pressed.connect(_on_run_as_client_pressed)


func _on_run_as_server_pressed():
	Logger.info("Running as server")
	$SelectRunMode.hide()
	var server = load("res://gmf/server/scenes/server/Server.tscn").instantiate()
	self.add_child(server)


func _on_run_as_client_pressed():
	Logger.info("Running as client")
