extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("enter_death_barrier"):
		body.enter_death_barrier()
