extends Node2D

enum MODES { SERVER, CLIENT }

var mode: MODES = MODES.SERVER


# Called when the node enters the scene tree for the first time.
func _ready():
	if mode == MODES.CLIENT:
		var client = load("res://example/scenes/world/Client.gd").new()
		client.name = "Client"
		add_child(client)
		$LoginPanel.show()


func set_client_mode():
	mode = MODES.CLIENT
