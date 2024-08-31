extends Timer


func _on_timeout() -> void:
	get_tree().reload_current_scene()
