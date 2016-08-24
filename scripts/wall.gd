
extends Area2D

func _on_Area2D_body_enter(body):
	if body.get_name() == "player":
		body.die()
