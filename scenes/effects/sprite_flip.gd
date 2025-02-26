extends Timer


@export var vertical_flips = true
var odd = false


func _ready() -> void:
	timeout.connect(on_timeout)

func on_timeout() -> void:
	if odd:
		odd = false
		get_parent().flip_h = !get_parent().flip_h
	else:
		odd = true
		if vertical_flips:
			get_parent().flip_v = !get_parent().flip_v
		else:
			get_parent().flip_h = !get_parent().flip_h
