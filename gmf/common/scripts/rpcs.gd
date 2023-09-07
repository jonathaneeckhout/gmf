extends Node

var account: Node
var player: Node
var clock: Node


func _ready():
	account = load("res://gmf/common/scripts/rpcs/account.gd").new()
	account.name = "Account"
	add_child(account)

	player = load("res://gmf/common/scripts/rpcs/player.gd").new()
	player.name = "Player"
	add_child(player)

	clock = load("res://gmf/common/scripts/rpcs/clock.gd").new()
	clock.name = "Clock"
	add_child(clock)
