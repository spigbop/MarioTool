extends Node
class_name MarioTool

enum DIRECTION { NORTH, SOUTH, WEST, EAST, PLAYER }
enum DIRECTION_H { WEST, EAST, PLAYER }
enum DIRECTION_V { NORTH, SOUTH, PLAYER }


static var inst: MarioTool = null

static var CURRENT_LEVEL: Node2D = null


static func _static_init() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	set_window_size(config.get_value("window", "window_scale"))
	if config.get_value("window", "fullscreen"):
		toggle_fullscreen()
	
	set_master_volume(config.get_value("bus", "master_volume"))
	set_music_volume(config.get_value("bus", "music_volume"))
	set_sound_volume(config.get_value("bus", "sound_volume"))


func _ready() -> void:
	inst = self
	
	get_viewport().focus_entered.connect(window_gained_focus)
	get_viewport().focus_exited.connect(window_lost_focus)
	
	if OS.is_debug_build():
		var console_resource = load("res://scenes/ui/menus/console_overlay.tscn")
		var console_instance = console_resource.instantiate()
		add_child(console_instance)
	
	Console.println(enter_level("demo_level"))


func _notification(noti):
	if noti == NOTIFICATION_WM_CLOSE_REQUEST:
		quit_to_desktop()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("misc_up_screen"):
		set_window_size(clamp(current_window_size + 1, MIN_WIN_SCALE, MAX_WIN_SCALE))
	if event.is_action_pressed("misc_down_screen"):
		set_window_size(clamp(current_window_size - 1, MIN_WIN_SCALE, MAX_WIN_SCALE))
	if event.is_action_pressed("misc_fullscreen"):
		toggle_fullscreen()





# =============
#  CONFIG FILE
# =============
const CONFIG_DEFAULTS = {
	"window,fullscreen": false,
	"window,window_scale": 2,
	
	"bus,master_volume": 0.5,
	"bus,music_volume": 1.0,
	"bus,sound_volume": 1.0
}

static var config_maps = {}

static var config: ConfigFile = null:
	get():
		if config == null:
			return load_config()
		return config

static func load_config() -> ConfigFile:
	config = ConfigFile.new()
	var state = config.load("user://config.cfg")
	if state != OK:
		return generate_config()
	return config

static func generate_config() -> ConfigFile:
	config = ConfigFile.new()
	
	for entry in CONFIG_DEFAULTS:
		var a = entry.split(',')
		config.set_value(a[0], a[1], CONFIG_DEFAULTS[entry])
	
	config.save("user://config.cfg")
	return config





# =========
#  WINDOWS
# =========
var skip_pause: bool = false
func window_gained_focus() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	if not skip_pause:
		get_tree().paused = false

func window_lost_focus() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(paused_volume))
	if get_tree().paused:
		skip_pause = true
	get_tree().paused = true


const MAX_WIN_SCALE: int = 6
const MIN_WIN_SCALE: int = 1
static var current_window_size: int = 2

static func set_window_size(scale: int) -> void:
	if DisplayServer.window_get_mode() == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	if DisplayServer.window_get_mode() == 0:
		var init_win_size: Vector2i = DisplayServer.window_get_size()
		var win_size: Vector2i = Vector2i(256 * scale, 224 * scale)
		var win_pos: Vector2i = DisplayServer.window_get_position()
		var delta: Vector2i = (init_win_size - win_size) / 2
		
		current_window_size = scale
		config_maps["window,window_scale"] = current_window_size
		
		DisplayServer.window_set_size(win_size)
		DisplayServer.window_set_position(win_pos + delta)

static var is_fullscreen: bool = DisplayServer.window_get_mode() > 2
static func toggle_fullscreen() -> void:
	DisplayServer.window_set_mode(Mathx.bool_gate(not is_fullscreen, 4, 0))
	is_fullscreen = not is_fullscreen
	config_maps["window,fullscreen"] = is_fullscreen





# =======
#  AUDIO
# =======
static var master_volume = 1.0
static var music_volume = 1.0
static var sound_volume = 1.0
static var paused_volume = 0.2

static func set_master_volume(multiplier: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(multiplier))
	master_volume = multiplier
	paused_volume = multiplier / 5
	config_maps["bus,master_volume"] = multiplier

static func set_music_volume(multiplier: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(multiplier))
	music_volume = multiplier
	config_maps["bus,music_volume"] = multiplier

static func set_sound_volume(multiplier: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound Effect"), linear_to_db(multiplier))
	sound_volume = multiplier
	config_maps["bus,sound_volume"] = multiplier





# =================
#  LEVELS & SCENES
# =================
const HUB_LEVEL_PATH = "world_map"
static var current_level_path = null

static func enter_level(level_path: String) -> String:
	var queue = CURRENT_LEVEL
	load_scene_from_path(level_path)
	if queue:
		queue.queue_free()
	return "loaded level: " + level_path

static func load_scene_from_path(level_path: String) -> void:
	load_scene(load("res://scenes/game/levels/" + level_path + ".tscn"))

static func load_scene(level_scene: PackedScene) -> void:
	if not level_scene:
		return
	current_level_path = level_scene.resource_path
	CURRENT_LEVEL = level_scene.instantiate()
	CURRENT_LEVEL.position = Vector2.ZERO
	inst.add_child(CURRENT_LEVEL)

static func dispose_level() -> void:
	current_level_path = null
	CURRENT_LEVEL.queue_free()


static func exit_level() -> void:
	if not current_level_path == null and not current_level_path == HUB_LEVEL_PATH:
		var queue = CURRENT_LEVEL
		load_scene_from_path(HUB_LEVEL_PATH)
		queue.queue_free()


static func reset_level() -> void:
	var queue = CURRENT_LEVEL
	load_scene(load(current_level_path))
	queue.queue_free()





# ==============
#  NODE GETTERS
# ==============
static func get_level_base() -> Level:
	if not CURRENT_LEVEL:
		return null
	return CURRENT_LEVEL.get_node_or_null("level")

static func get_main_camera() -> Camera2D:
	if not CURRENT_LEVEL:
		return null
	return CURRENT_LEVEL.get_node_or_null("level/main_camera")

static func get_music() -> Music:
	if not CURRENT_LEVEL:
		return null
	return CURRENT_LEVEL.get_node_or_null("level/main_camera/level_music")

static func get_death_timer() -> Timer:
	if not CURRENT_LEVEL:
		return null
	return CURRENT_LEVEL.get_node_or_null("level/main_camera/death_timer")

static func get_level_overlay() -> Node2D:
	if not CURRENT_LEVEL:
		return null
	return CURRENT_LEVEL.get_node_or_null("level/main_camera/level_overlay")

static func get_player() -> Player:
	if not CURRENT_LEVEL:
		return null
	return CURRENT_LEVEL.get_node_or_null("player")





# =================
#  PROCESS METHODS
# =================
static func set_vsync(enabled: bool) -> String:
	DisplayServer.window_set_vsync_mode(int(enabled))
	return "Vsync " + Mathx.bool_gate(enabled, "enabled.", "disabled.")

static func fps() -> float:
	return Engine.get_frames_per_second()

static func quit_to_desktop() -> void:
	for entry in config_maps:
		var a = entry.split(',')
		config.set_value(a[0], a[1], config_maps[entry])
	config.save("user://config.cfg")
	inst.get_tree().quit()





# =================
#  MISC CONNECTORS
# =================
static func get_remaining_lives() -> String:
	return str(Player.remaining_lives).pad_zeros(2)
