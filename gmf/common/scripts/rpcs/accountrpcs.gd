extends Node

@rpc("call_remote", "any_peer", "reliable") func create_account(username, _password):
	if not is_multiplayer_authority():
		return

	Logger.info("Creating account for user=[%s]" % username)
	var id = multiplayer.get_remote_sender_id()

	# create_account_response.rpc_id(id, true, "Username already exists")
	create_account_response.rpc_id(id, false)


@rpc("call_remote", "authority", "reliable")
func create_account_response(error: bool, reason: String = ""):
	Signals.account_created.emit({"error": error, "reason": reason})
