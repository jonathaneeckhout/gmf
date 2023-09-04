extends Node


func _ready():
	if not Global.load_client_env_variables():
		Logger.error("Could not load client's env variables, stopping client")
		get_tree().quit()
		return

	multiplayer.connected_to_server.connect(_on_connection_succeeded)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

	Global.client = self


func connect_to_server(address, port) -> bool:
	var client = ENetMultiplayerPeer.new()

	var error = client.create_client(address, port)
	if error != OK:
		Logger.warn("Failed to create client")
		return false

	if client.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		Logger.warn("Failed to connect to server")
		return false

	var client_tls_options: TLSOptions

	if Global.env_debug:
		client_tls_options = TLSOptions.client_unsafe()
	else:
		client_tls_options = TLSOptions.client()

	error = client.host.dtls_client_setup(address, client_tls_options)
	if error != OK:
		Logger.warn("Failed to connect via DTLS")
		return false

	multiplayer.multiplayer_peer = client

	return true


func _on_connection_succeeded():
	Logger.info("Connection succeeded")
	Signals.client_connected.emit(true)


func _on_server_disconnected():
	Logger.info("Server disconnected")
	Signals.client_connected.emit(false)


func _on_connection_failed():
	Logger.warn("Connection failed")
	Signals.client_connected.emit(false)
