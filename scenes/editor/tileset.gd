extends TileMapLayer


var inside: bool = false
@onready var selection: Sprite2D = $selection


func _notification(what):
	match what:
		NOTIFICATION_WM_MOUSE_EXIT:
			inside = false
		NOTIFICATION_WM_MOUSE_ENTER:
			inside = true


func _process(delta: float) -> void:
	if Input.is_action_pressed("editor_action") and inside:
		var cell_pos = local_to_map(get_local_mouse_position())
		MarioTool.editor.tiles_selected_atlas = cell_pos
		selection.position = Vector2(cell_pos.x * 16 + 8, cell_pos.y * 16 + 8)
