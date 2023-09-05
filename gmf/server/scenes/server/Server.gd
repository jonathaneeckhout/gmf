extends Node


func _ready():
	if not Gmf.global.load_server_env_variables():
		Gmf.logger.error("Could not load server's env variables, stopping server")
		get_tree().quit()
		return

	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	if not start():
		Gmf.logger.error("Failed to start server, stopping server")
		get_tree().quit()
		return

	Gmf.global.server = self


func get_tls_options() -> TLSOptions:
	var cert_file = FileAccess.open(Gmf.global.env_server_crt, FileAccess.READ)
	if cert_file == null:
		Gmf.logger.warn("Failed to open server certificate %s" % Gmf.global.env_server_crt)
		return null

	var key_file = FileAccess.open(Gmf.global.env_server_key, FileAccess.READ)
	if key_file == null:
		Gmf.logger.warn("Failed to open server key %s" % Gmf.global.env_server_key)
		return null

	var cert_string = cert_file.get_as_text()
	var key_string = key_file.get_as_text()

	var cert = X509Certificate.new()

	var error = cert.load_from_string(cert_string)
	if error != OK:
		Gmf.logger.warn("Failed to load certificate")
		return null

	var key = CryptoKey.new()

	error = key.load_from_string(key_string)
	if error != OK:
		Gmf.logger.warn("Failed to load key")
		return null

	return TLSOptions.server(key, cert)


func start() -> bool:
	var server = ENetMultiplayerPeer.new()

	var error = server.create_server(Gmf.global.env_server_port, Gmf.global.env_server_max_peers)
	if error != OK:
		Gmf.logger.warn("Failed to create server")
		return false

	if server.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		Gmf.logger.warn("Failed to start server")
		return false

	var server_tls_options = get_tls_options()
	if server_tls_options == null:
		Gmf.logger.warn("Failed to load tls options")
		return false

	error = server.host.dtls_server_setup(server_tls_options)
	if error != OK:
		Gmf.logger.warn("Failed to setup DTLS")
		return false

	multiplayer.multiplayer_peer = server

	Gmf.logger.info("Started DTLS server")

	return true


func _on_peer_connected(id):
	Gmf.logger.info("Peer connected %d" % id)


func _on_peer_disconnected(id):
	Gmf.logger.info("Peer disconnected %d" % id)
