extends Button


@export var target: Window


func _pressed() -> void:
	target.visible = not target.visible
