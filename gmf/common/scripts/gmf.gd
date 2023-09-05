extends Node

var logger: Node
var env: Node
var global: Node
var signals: Node
var account_rpcs: Node

var server: Node
var client: Node


func _ready():
	logger = load("res://addons/logger/logger.gd").new()
	logger.name = "Logger"
	add_child(logger)

	env = load("res://gmf/common/scripts/godotenv/scripts/env.gd").new()
	env.name = "Env"
	add_child(env)

	global = load("res://gmf/common/scripts/global.gd").new()
	global.name = "Global"
	add_child(global)

	signals = load("res://gmf/common/scripts/signals.gd").new()
	signals.name = "Signals"
	add_child(signals)

	account_rpcs = load("res://gmf/common/scripts/rpcs/accountrpcs.gd").new()
	account_rpcs.name = "AccountRPCs"
	add_child(account_rpcs)


func init_server() -> bool:
	if not Gmf.global.load_server_env_variables():
		Gmf.logger.error("Could not load server's env variables, stopping server")
		return false

	server = load("res://gmf/server/scripts/server.gd").new()
	server.name = "Server"
	add_child(server)

	return true


func init_client() -> bool:
	if not Gmf.global.load_client_env_variables():
		Gmf.logger.error("Could not load client's env variables, stopping client")
		return false

	client = load("res://gmf/client/scripts/client.gd").new()
	client.name = "Client"
	add_child(client)

	return true
