extends Timer


@export var subject: PackedScene = null
@export var delete_original = false

@onready var parent = get_parent()


func _on_timeout() -> void:
	var inst = subject.instantiate()
	inst.position = parent.position
	parent.add_sibling(inst)
	if delete_original:
		parent.queue_free()
