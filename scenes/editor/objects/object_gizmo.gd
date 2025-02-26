extends Sprite2D


func _ready() -> void:
	if MarioTool.editor and MarioTool.editor.is_editing:
		visible = true
