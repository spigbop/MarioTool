extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if(body.has_method("coin_picker")):
		body.coin_picker()
		queue_free()
