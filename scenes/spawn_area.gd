extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("enter_spawn_area"):
		body.enter_spawn_area()


func _on_area_exited(area: Area2D) -> void:
	if area.has_method("exit_spawn_area"):
		area.exit_spawn_area()

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("exit_spawn_area"):
		body.exit_spawn_area()
