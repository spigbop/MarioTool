extends Area2D


func _on_body_entered(body: Node2D) -> void:
	collect(body)

func bumpable_collectable(body: Node2D):
	# play coin pop effect
	collect(body)
	
func collect(body: Node2D) -> void:
	if(body.has_method("coin_picker")):
		body.coin_picker()
		queue_free()
