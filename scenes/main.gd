extends Node
class_name MarioTool

enum DIRECTION { NORTH, SOUTH, WEST, EAST, PLAYER }
enum DIRECTION_H { WEST, EAST, PLAYER }
enum DIRECTION_V { NORTH, SOUTH, PLAYER }


const CONFIG = {
	"window,fullscreen": false,
	"window,window_scale": 2,
	
	"bus,master_volume": 1.0,
	"bus,music_volume": 1.0,
	"bus,sound_volume": 1.0
}


static var BUS_MASTER_VOLUME: float = 1.0
static var BUS_PAUSED_VOLUME: float = 0.0


static var inst: MarioTool = null

static var CURRENT_LEVEL: Node2D = null


static func _static_init() -> void:
	set_window_size(config.get_value("window", "window_scale"))
	if config.get_value("window", "fullscreen"):
		toggle_fullscreen()
	
	BUS_MASTER_VOLUME = config.get_value("bus", "master_volume")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(BUS_MASTER_VOLUME))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(config.get_value("bus", "music_volume")))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound Effect"), linear_to_db(config.get_value("bus", "sound_volume")))
	
	BUS_PAUSED_VOLUME = BUS_MASTER_VOLUME / 5


func _ready() -> void:
	inst = self
	
	get_viewport().focus_entered.connect(window_gained_focus)
	get_viewport().focus_exited.connect(window_lost_focus)
	
	load_level_from_path("res://scenes/game/levels/demo_level.tscn")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("misc_up_screen"):
		set_window_size(clamp(current_window_size + 1, MIN_WIN_SCALE, MAX_WIN_SCALE))
	elif Input.is_action_just_pressed("misc_down_screen"):
		set_window_size(clamp(current_window_size - 1, MIN_WIN_SCALE, MAX_WIN_SCALE))
	
	if Input.is_action_just_pressed("misc_fullscreen"):
		toggle_fullscreen()


func _notification(noti):
	if noti == NOTIFICATION_WM_CLOSE_REQUEST:
		config.set_value("window", "fullscreen", is_fullscreen)
		config.set_value("window", "window_scale", current_window_size)
		
		config.set_value("bus", "master_volume", BUS_MASTER_VOLUME)
		config.set_value("bus", "music_volume", db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))))
		config.set_value("bus", "sound_volume", db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound Effect"))))
		
		config.save("user://config.cfg")
		get_tree().quit()


# Config file
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
	
	for entry in CONFIG:
		var a = entry.split(',')
		config.set_value(a[0], a[1], CONFIG[entry])
	
	config.save("user://config.cfg")
	return config


# Window management
var skip_pause = false
func window_gained_focus() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(BUS_MASTER_VOLUME))
	if not skip_pause:
		get_tree().paused = false

func window_lost_focus() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(BUS_PAUSED_VOLUME))
	if get_tree().paused:
		skip_pause = true
	get_tree().paused = true


const MAX_WIN_SCALE: int = 10
const MIN_WIN_SCALE: int = 1
static var current_window_size: int = 2

static func set_window_size(scale: int) -> void:
	if DisplayServer.window_get_mode() == 0:
		var init_win_size: Vector2i = DisplayServer.window_get_size()
		var win_size: Vector2i = Vector2i(256 * scale, 224 * scale)
		var win_pos: Vector2i = DisplayServer.window_get_position()
		var delta: Vector2i = (init_win_size - win_size) / 2
		
		current_window_size = scale
		DisplayServer.window_set_size(win_size)
		DisplayServer.window_set_position(win_pos + delta)

static var is_fullscreen: bool = DisplayServer.window_get_mode() > 2
static func toggle_fullscreen() -> void:
	DisplayServer.window_set_mode(Mathx.bool_gate(not is_fullscreen, 3, 0))
	is_fullscreen = not is_fullscreen



# Level management
const HUB_LEVEL_PATH = "res://scenes/game/levels/world_map.tscn"
static var current_level_path = null

static func load_level_from_path(level_path) -> void:
	load_level(load(level_path))

static func load_level(level_scene: PackedScene) -> void:
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
		load_level_from_path(HUB_LEVEL_PATH)
		queue.queue_free()


static func reset_level() -> void:
	var queue = CURRENT_LEVEL
	load_level_from_path(current_level_path)
	queue.queue_free()


static func get_level_base() -> Node2D:
	return CURRENT_LEVEL.get_node_or_null("level")

static func get_main_camera() -> Camera2D:
	return CURRENT_LEVEL.get_node_or_null("level/main_camera")

static func get_music() -> Music:
	return CURRENT_LEVEL.get_node_or_null("level/main_camera/level_music")

static func get_death_timer() -> Timer:
	return CURRENT_LEVEL.get_node_or_null("level/death_timer")

static func get_player() -> Player:
	return CURRENT_LEVEL.get_node_or_null("player")
