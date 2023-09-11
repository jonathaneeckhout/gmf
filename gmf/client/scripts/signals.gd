extends Node

signal connected(connected: bool)

signal account_created(response: Dictionary)
signal authenticated(response: bool)

signal player_added(id: int, username: String, pos: Vector2)
signal player_state_changed(new_state: String)
