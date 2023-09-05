extends Node

var logger: Node
var env: Node
var global: Node
var signals: Node
var account_rpc: Node


func _ready():
	logger = load("res://addons/logger/logger.gd").new()
	add_child(logger)

	env = load("res://gmf/common/scripts/godotenv/scripts/env.gd").new()
	add_child(env)

	global = load("res://gmf/common/scripts/global.gd").new()
	add_child(global)

	signals = load("res://gmf/common/scripts/signals.gd").new()
	add_child(signals)

	account_rpc = load("res://gmf/common/scripts/rpcs/accountrpcs.gd").new()
	add_child(account_rpc)
