extends Timer


var odd = false


func _on_timeout() -> void:
	if odd:
		odd = false
		get_parent().flip_h = !get_parent().flip_h
	else:
		odd = true
		get_parent().flip_v = !get_parent().flip_v
