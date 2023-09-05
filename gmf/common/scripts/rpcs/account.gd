extends Node

@rpc("call_remote", "any_peer", "reliable") func create_account(username, password):
	if not is_multiplayer_authority():
		return

	Gmf.logger.info("Creating account for user=[%s]" % username)
	var id = multiplayer.get_remote_sender_id()

	if Gmf.server.database.create_account(username, password):
		create_account_response.rpc_id(id, false, "Account created")
	else:
		create_account_response.rpc_id(id, true, "Failed to create account")


@rpc("call_remote", "authority", "reliable")
func create_account_response(error: bool, reason: String = ""):
	Gmf.signals.account_created.emit({"error": error, "reason": reason})
