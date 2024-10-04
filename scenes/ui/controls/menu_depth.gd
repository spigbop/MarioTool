extends Node
class_name MenuDepth


@export var focused: bool = false:
	set(newval):
		focused = newval
		if not newval and par.boss.has_method("on_depth_exit"):
			par.boss.on_depth_exit(self.name)
		set_process(focused)
@export var on_just_press = false
@export var speed = 0.09
@export var value: float = 0.0
@export var ceiling: float = 1.0
@export var flr: float = 0.0
@export var increment: float = 0.1

@onready var par = get_parent()

@export var connection: String = "<null>"
@onready var connector: Node = get_node_or_null(connection)


func _ready() -> void:
	set_process(false)


var cooldown: float = 0.0
func _process(delta: float) -> void:
	if connector.value:
		value = connector.value
	
	if focused and Input.is_action_just_pressed("jump_accept"):
		focused = not focused
		get_parent().focused = true
	
	cooldown -= delta
	if not on_just_press and cooldown > 0.0:
		return
	
	if not on_just_press and Input.is_action_pressed("right"):
		cooldown = speed
		value = clamp(value + increment, flr, ceiling)
		call_on_boss("on_depth_change", value)
	
	if not on_just_press and Input.is_action_pressed("left"):
		cooldown = speed
		value = clamp(value - increment, flr, ceiling)
		call_on_boss("on_depth_change", value)
	
	if on_just_press and Input.is_action_just_pressed("right"):
		value = clamp(value + increment, flr, ceiling)
		call_on_boss("on_depth_change", value)
	
	if on_just_press and Input.is_action_just_pressed("left"):
		value = clamp(value - increment, flr, ceiling)
		call_on_boss("on_depth_change", value)


func call_on_boss(function: String, val: Variant) -> void:
	if par.boss.has_method(function):
		par.boss.call_deferred(function, val, self.name)
