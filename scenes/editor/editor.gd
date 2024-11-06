extends Node2D
class_name MarioToolEditor


var level_path: String = "<new>"
var is_editing = true
var mouse: Vector2 = Vector2.ZERO

var inside: bool = true

@onready var toolbox: Window = $toolbox
@onready var tiles: Window = $tiles
var tiles_selected_atlas: Dictionary = {
	Vector2i(0, 0): Vector2i(3, 3)
}
var player_spawn: Vector2 = Vector2.ZERO


func _notification(what):
	match what:
		NOTIFICATION_WM_MOUSE_EXIT:
			inside = false
		NOTIFICATION_WM_MOUSE_ENTER:
			inside = true


func _ready() -> void:
	if not DirAccess.dir_exists_absolute("user://editor/"):
		DirAccess.make_dir_absolute("user://editor/")
	
	open_fd.file_selected.connect(open_level)
	save_fd.file_selected.connect(set_level_path)
	
	var win = get_window()
	win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP_HEIGHT
	win.unresizable = false
	
	toolbox.position.y -= MarioTool.current_window_size * 112 + tiles.size.y / 2 + 20
	tiles.position.x -= MarioTool.current_window_size * 128 + tiles.size.x / 2 + 20
	
	if level_path == "<new>":
		open_level("res://scenes/game/levels/template_level.tscn")
	else:
		open_level(level_path)
	
	MarioTool.set_window_size(MarioTool.current_window_size)


func exit_editor() -> void:
	var win = get_window()
	win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	win.unresizable = true
	MarioTool.set_window_size(MarioTool.current_window_size)
	DisplayServer.window_set_title("Mario Tool")
	queue_free()


@onready var open_fd: FileDialog = $dials/open
@onready var save_fd: FileDialog = $dials/save


func _process(_delta: float) -> void:
	mouse = get_global_mouse_position()
	
	if Input.is_action_just_pressed("editor_open_file"):
		open_fd.popup()
	if Input.is_action_just_pressed("editor_save_file"):
		save_level()
	if Input.is_action_just_pressed("editor_test"):
		toggle_testing()


func open_level(pth: String) -> String:
	var packed: PackedScene = load(pth)
	MarioTool.dispose_level()
	MarioTool.load_scene(packed, false, false)
	var music = MarioTool.get_music()
	if music:
		music.force_stop()
	var cam = MarioTool.get_main_camera()
	cam.set_script(load("res://scenes/editor/editor_camera.gd"))
	cam.set_process(true)
	var player = MarioTool.get_player()
	if player:
		player.queue_free()
	DisplayServer.window_set_title(pth.split("/")[-1])
	return "Editor opened level: " + pth


func save_level() -> String:
	if not is_editing:
		return "Stop testing first."
	
	if level_path == "<new>":
		save_fd.popup()
		return "Select a path from the file dialog..."
	
	MarioTool.get_level_base().player_spawn = player_spawn
	
	var packed: PackedScene = PackedScene.new()
	packed.pack(MarioTool.CURRENT_LEVEL)
	ResourceSaver.save(packed, level_path)
	return "Editor saved level: " + level_path


func set_level_path(pth: String) -> String:
	level_path = pth
	if not level_path.ends_with(".tscn"):
		level_path = level_path + ".tscn"
	save_level()
	return "Editor set path as: " + pth


@onready var grid: ParallaxBackground = $grid
@onready var gizmos: CanvasLayer = $gizmos
func toggle_testing() -> void:
	is_editing = not is_editing
	grid.visible = is_editing
	gizmos.visible = is_editing
	if is_editing:
		MarioTool.get_player().queue_free()
		var cam = MarioTool.get_main_camera()
		cam.get_node("testing_nodes").queue_free()
		cam.set_script(load("res://scenes/editor/editor_camera.gd"))
		cam.set_process(true)
	else:
		var cam = MarioTool.get_main_camera()
		var packed_nodes: PackedScene = load("res://scenes/game/level_nodes.tscn")
		var level_nodes: Node2D = packed_nodes.instantiate()
		level_nodes.name = "testing_nodes"
		cam.add_child(level_nodes)
		var packed_player: PackedScene = load("res://scenes/objects/player.tscn")
		var player: Player = packed_player.instantiate()
		player.position = MarioTool.get_level_base().player_spawn
		MarioTool.CURRENT_LEVEL.add_child(player)
		cam.set_script(load("res://scenes/game/level_camera.gd"))
		cam.player = player
		cam.level_dimensions = MarioTool.get_level_base().level_dimensions
		cam.set_physics_process(true)
