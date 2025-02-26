extends Button


@export var type: EditorCamera.TOOL_TYPE


func _pressed() -> void:
	EditorCamera.type = type
