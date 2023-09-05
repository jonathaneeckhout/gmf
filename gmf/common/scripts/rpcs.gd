extends Node

var account: Node


func _ready():
	account = load("res://gmf/common/scripts/rpcs/account.gd").new()
	account.name = "Account"
	add_child(account)
