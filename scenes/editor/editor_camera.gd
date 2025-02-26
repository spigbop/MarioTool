extends Camera2D
class_name EditorCamera


enum TOOL_TYPE {
	TILES,
	OBJECTS,
	SELECT,
	SEL_TILE,
	SEL_OBJECT,
	ERASE,
	PAN }
static var type: TOOL_TYPE = TOOL_TYPE.PAN


static var frozen: int = false


static var foreground: TileMapLayer:
	get():
		if not is_instance_valid(foreground):
			foreground = MarioTool.get_level_base().maps.get_node("foreground")
		return foreground

static var contents: Node2D:
	get():
		if not is_instance_valid(contents):
			contents = MarioTool.get_level_base().get_parent().get_node("contents")
		return contents

var object_subaction_zone: Area2D:
	get():
		if not is_instance_valid(object_subaction_zone):
			object_subaction_zone = MarioTool.editor.get_node("object_act_zone")
		return object_subaction_zone


func _notification(what: int) -> void:
	if what == NOTIFICATION_VP_MOUSE_EXIT:
		pan_init_pos = null
		pan_init_cam = null


func _process(delta: float) -> void:
	if frozen:
		return
	
	var vel_x: float = Input.get_axis("left", "right") * delta * 200.0 * Mathx.bool_gate(Input.is_action_pressed("run_fire_decline"), 2.0, 1.0)
	var vel_y: float = Input.get_axis("up_interact", "down_duck") * delta * 200.0 * Mathx.bool_gate(Input.is_action_pressed("run_fire_decline"), 2.0, 1.0)
	position.x += vel_x
	position.y += vel_y
	
	if not vel_y == 0.0:
		update_clear_color()
	
	if Input.is_action_pressed("editor_action") and MarioTool.editor.inside:
		editor_action()
	
	if Input.is_action_just_released("editor_action"):
		once = false
		pan_init_pos = null
		pan_init_cam = null
	
	if Input.is_action_pressed("editor_subaction") and MarioTool.editor.inside:
		editor_subaction()


var hierarchy: EditorHierarchy:
	get():
		if not is_instance_valid(hierarchy):
			hierarchy = MarioTool.editor.get_node("hierarchy/tree")
		return hierarchy


var properties: Tree:
	get():
		if not is_instance_valid(properties):
			properties = MarioTool.editor.get_node("properties/tree")
		return properties


var player_spawn_gizmo: Sprite2D:
	get():
		if not is_instance_valid(player_spawn_gizmo):
			player_spawn_gizmo = MarioTool.editor.get_node("gizmos/player_spawn")
		return player_spawn_gizmo


static var action_iteration: int = 0
var once: bool = false
var pan_init_pos: Variant = null
var pan_init_cam: Variant = null
func editor_action() -> void:
	match type:
		TOOL_TYPE.ERASE:
			editor_subaction()
			return
		
		TOOL_TYPE.TILES:
			var cell_pos = foreground.local_to_map(to_local(MarioTool.editor.mouse) + position)
			for index: Vector2i in MarioTool.editor.tiles_selected_atlas:
				foreground.set_cell(cell_pos + index, foreground.tile_set.get_source_id(0), MarioTool.editor.tiles_selected_atlas[index])
		
		TOOL_TYPE.OBJECTS:
			if once:
				return
			var grid_pos = foreground.local_to_map(to_local(MarioTool.editor.mouse) + position) * 16.0 + Vector2(8.0, 8.0)
			
			if MarioTool.editor.objects_selected_path == "res://scenes/editor/gizmos/player_spawn.tscn":
				player_spawn_gizmo.position = grid_pos
				MarioTool.editor.player_spawn = grid_pos
				return
			
			var packed: PackedScene = load(MarioTool.editor.objects_selected_path)
			var instance: Node2D = packed.instantiate()
			
			instance.position = grid_pos
			instance.name = str(action_iteration) + "_" + instance.name
			action_iteration += 1
			
			contents.add_child(instance)
			hierarchy.add(instance, EditorHierarchy.ICON.GENERIC)
			properties.load_instance(instance)
			
			once = true
		
		TOOL_TYPE.PAN:
			if not pan_init_pos:
				pan_init_pos = to_local(MarioTool.editor.mouse)
			if not pan_init_cam:
				pan_init_cam = position
			var delta = to_local(MarioTool.editor.mouse) - pan_init_pos
			position = pan_init_cam - delta
			update_clear_color()


func editor_subaction() -> void:
	# Erase: Tiles
	var cell_pos = foreground.local_to_map(to_local(MarioTool.editor.mouse) + position)
	for index: Vector2i in MarioTool.editor.tiles_selected_atlas:
		foreground.erase_cell(cell_pos + index)
	
	# Erase: Content
	object_subaction_zone.active = true
	object_subaction_zone.position = foreground.local_to_map(to_local(MarioTool.editor.mouse) + position) * 16.0 + Vector2(8.0, 8.0)


func update_clear_color() -> void:
	if position.y > 0.0:
		RenderingServer.set_default_clear_color(Color.from_string("183060", Color.BLACK))
	else:
		RenderingServer.set_default_clear_color(Color.from_string("383868", Color.BLACK))
