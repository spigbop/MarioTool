extends Node
class_name MarioTool

enum DIRECTION { NORTH, SOUTH, WEST, EAST }


static var BUS_MASTER_VOLUME: float = 1.0
static var BUS_PAUSED_VOLUME: float = 0.0


static var CURRENT_LEVEL: Node2D = null
static var MAIN_CAMERA: Camera2D = null


static func _static_init() -> void:
	BUS_PAUSED_VOLUME = BUS_MASTER_VOLUME / 5

# Called when game starts
func _ready() -> void:
	get_viewport().focus_entered.connect(window_gained_focus)
	get_viewport().focus_exited.connect(window_lost_focus)
	
	var level_scene = load("res://scenes/game/levels/demo_level.tscn")
	CURRENT_LEVEL = level_scene.instantiate()
	CURRENT_LEVEL.position = Vector2.ZERO
	add_child(CURRENT_LEVEL)
	
	MAIN_CAMERA = CURRENT_LEVEL.get_node("main_camera")


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
