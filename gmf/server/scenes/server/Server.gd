extends Node


func _ready():
	if not Global.load_server_env_variables():
		Logger.error("Could not load server's env variables, stopping server")
		get_tree().quit()

	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	if not start():
		Logger.error("Failed to start server, stopping server")
		get_tree().quit()


func get_tls_options() -> TLSOptions:
	var cert_file = FileAccess.open(Global.env_server_crt, FileAccess.READ)
	if cert_file == null:
		Logger.warn("Failed to open server certificate %s" % Global.env_server_crt)
		return null

	var key_file = FileAccess.open(Global.env_server_key, FileAccess.READ)
	if key_file == null:
		Logger.warn("Failed to open server key %s" % Global.env_server_key)
		return null

	var cert_string = cert_file.get_as_text()
	var key_string = key_file.get_as_text()

	var cert = X509Certificate.new()

	var error = cert.load_from_string(cert_string)
	if error != OK:
		Logger.warn("Failed to load certificate")
		return null

	var key = CryptoKey.new()

	error = key.load_from_string(key_string)
	if error != OK:
		Logger.warn("Failed to load key")
		return null

	return TLSOptions.server(key, cert)


func start() -> bool:
	var server = ENetMultiplayerPeer.new()

	var error = server.create_server(Global.env_server_port, Global.env_server_max_peers)
	if error != OK:
		Logger.warn("Failed to create server")
		return false

	if server.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		Logger.warn("Failed to start server")
		return false

	var server_tls_options = get_tls_options()
	if server_tls_options == null:
		Logger.warn("Failed to load tls options")
		return false

	error = server.host.dtls_server_setup(server_tls_options)
	if error != OK:
		Logger.warn("Failed to setup DTLS")
		return false

	multiplayer.multiplayer_peer = server

	Logger.info("Started DTLS server")

	return true


func _on_peer_connected(id):
	Logger.info("Peer connected ", id)


func _on_peer_disconnected(id):
	Logger.info("Peer disconnected ", id)
