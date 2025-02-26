extends TileMapLayer


var inside: bool = false
var currently_selecting: bool = false


func _notification(what):
	match what:
		NOTIFICATION_WM_MOUSE_EXIT:
			inside = false
		NOTIFICATION_WM_MOUSE_ENTER:
			inside = true


var cell_selection: Rect2i = Rect2i(3, 3, 1, 1)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("editor_action") and inside:
		cell_selection.position = local_to_map(get_local_mouse_position())
		MarioTool.editor.tiles_selected_atlas.clear()
		currently_selecting = true
	
	if Input.is_action_pressed("editor_action") and inside:
		var hovered_cell = local_to_map(get_local_mouse_position())
		cell_selection.size = hovered_cell - cell_selection.position
		cell_selection = cell_selection.abs()
		update_selection_sprites()
	
	if Input.is_action_just_released("editor_action") and currently_selecting:
		currently_selecting = false
		EditorCamera.type = EditorCamera.TOOL_TYPE.TILES
		for sx in cell_selection.size.x + 1:
			for sy in cell_selection.size.y + 1:
				MarioTool.editor.tiles_selected_atlas[Vector2i(sx, sy)] = Vector2i(cell_selection.position.x + sx, cell_selection.position.y + sy)


@onready var selection: Node2D = $selection
@onready var piles_x: Array = [
	$selection/top,
	$selection/bottom ]
@onready var piles_y: Array = [
	$selection/left,
	$selection/right ]


func update_selection_sprites() -> void:
	selection.position = cell_selection.position * 16.0
	for node in piles_x:
		node.position.x = (cell_selection.size.x + 1) * 8.0 + .5
		node.scale.x = (cell_selection.size.x + 1) * 16.0
	for node in piles_y:
		node.position.y = (cell_selection.size.y + 1) * 8.0 + .5
		node.scale.y = (cell_selection.size.y + 1) * 16.0 + 2.0
	piles_x[1].position.y = (cell_selection.size.y + 1) * 16.0 + 1.0
	piles_y[1].position.x = (cell_selection.size.x + 1) * 16.0 + .5
