extends GMFWorld


func _ready():
	super()

	if not Gmf.is_server():
		var client = load("res://example/scenes/world/Client.gd").new()
		client.name = "Client"
		add_child(client)
		$LoginPanel.show()
