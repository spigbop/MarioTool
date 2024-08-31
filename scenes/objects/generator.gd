extends Marker2D


@export var subject: PackedScene = null


func _on_timer_timeout() -> void:
	var inst = subject.instantiate()
	inst.position = position
	add_sibling(inst)
	if inst.has_method("appear"):
		inst.appear()
