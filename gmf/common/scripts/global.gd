extends Node

var env_server_port = 0
var env_server_max_peers= 0
var env_server_crt = ""
var env_server_key = ""


func load_server_env_variables():
	var env_port_str = Env.get_value("SERVER_PORT")
	if env_port_str == "":
		return false

	env_server_port = int(env_port_str)

	var env_max_peers_str = Env.get_value("SERVER_MAX_PEERS")
	if env_max_peers_str == "":
		return false

	env_server_max_peers = int(env_max_peers_str)

	env_server_crt = Env.get_value("SERVER_CRT")
	if env_server_crt == "":
		return false

	env_server_key = Env.get_value("SERVER_KEY")
	if env_server_key == "":
		return false

	return true
