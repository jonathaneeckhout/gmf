extends Node


func _ready():
	multiplayer.connected_to_server.connect(_on_connection_succeeded)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func connect_to_server(address, port) -> bool:
	var client = ENetMultiplayerPeer.new()

	var error = client.create_client(address, port)
	if error != OK:
		Gmf.logger.warn("Failed to create client")
		return false

	if client.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		Gmf.logger.warn("Failed to connect to server")
		return false

	var client_tls_options: TLSOptions

	if Gmf.global.env_debug:
		client_tls_options = TLSOptions.client_unsafe()
	else:
		client_tls_options = TLSOptions.client()

	error = client.host.dtls_client_setup(address, client_tls_options)
	if error != OK:
		Gmf.logger.warn("Failed to connect via DTLS")
		return false

	multiplayer.multiplayer_peer = client

	return true


func _on_connection_succeeded():
	Gmf.logger.info("Connection succeeded")
	Gmf.signals.client_connected.emit(true)


func _on_server_disconnected():
	Gmf.logger.info("Server disconnected")
	Gmf.signals.client_connected.emit(false)


func _on_connection_failed():
	Gmf.logger.warn("Connection failed")
	Gmf.signals.client_connected.emit(false)
