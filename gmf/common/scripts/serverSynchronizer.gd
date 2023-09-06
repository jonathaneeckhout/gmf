extends Node2D

var parent: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	parent = $"../"


@rpc("call_remote", "authority", "unreliable") func sync(
	pos: Vector2,
):
	parent.position = pos
