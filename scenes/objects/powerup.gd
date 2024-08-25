extends Area2D


@export var tier = 1


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("powerup_picker"):
		body.powerup_picker(tier)
		get_parent().queue_free()
