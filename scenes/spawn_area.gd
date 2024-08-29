extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("enter_spawn_area"):
		body.enter_spawn_area()
