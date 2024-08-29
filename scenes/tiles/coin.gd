extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("coin_picker"):
		collect(body)

func collect(body: Node2D) -> void:
	body.coin_picker()
	# increase level coin count by 1
	# if it hits 100 AND level has it enabled, grant a 1-up
	queue_free()
