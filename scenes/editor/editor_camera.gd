extends Camera2D
class_name EditorCamera


var foreground: TileMapLayer:
	get():
		if not is_instance_valid(foreground):
			foreground = MarioTool.get_level_base().maps.get_node("foreground")
		return foreground


func _process(delta: float) -> void:
	var vel_x: float = Input.get_axis("left", "right") * delta * 200.0 * Mathx.bool_gate(Input.is_action_pressed("run_fire_decline"), 2.0, 1.0)
	var vel_y: float = Input.get_axis("up_interact", "down_duck") * delta * 200.0 * Mathx.bool_gate(Input.is_action_pressed("run_fire_decline"), 2.0, 1.0)
	position.x += vel_x
	position.y += vel_y
	
	if not vel_y == 0.0:
		if position.y > 0.0:
			RenderingServer.set_default_clear_color(Color.from_string("183060", Color.BLACK))
		else:
			RenderingServer.set_default_clear_color(Color.from_string("383868", Color.BLACK))
	
	if Input.is_action_pressed("editor_action") and MarioTool.editor.inside:
		var cell_pos = foreground.local_to_map(to_local(MarioTool.editor.mouse) + position)
		foreground.set_cell(cell_pos, foreground.tile_set.get_source_id(0), MarioTool.editor.tiles_selected_atlas)
	
	if Input.is_action_pressed("editor_subaction") and MarioTool.editor.inside:
		var cell_pos = foreground.local_to_map(to_local(MarioTool.editor.mouse) + position)
		foreground.erase_cell(cell_pos)
