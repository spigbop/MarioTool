extends Node


@export var bouncebox_name = "bounce"
@export var autostart = true
@export var speed: float = 3.75
@export var bounce_speed: float = 1.6
@export var gravity_multiplier: float = 0.8

var direction = 1.0
var bounce_velocity = 1.0
var last_bounce_position = 0.0


@onready var rigid = get_parent()


func _ready() -> void:
	set_process(false)
	
	var bouncebox = null
	if bouncebox_name == "..":
		bouncebox = rigid
	else:
		bouncebox = rigid.find_child(bouncebox_name)
		
	if bouncebox:
		bouncebox.body_shape_entered.connect(shape_entered)
	
	if autostart:
		spawn()

func spawn() -> void:
	set_process(true)


func _physics_process(delta: float) -> void:
	rigid.logical_position = rigid.position
	
	rigid.position.y += bounce_velocity * bounce_speed # accel = 9.8
	rigid.position.x += direction * speed # accel = 0
	
	bounce_velocity += bounce_speed * gravity_multiplier * 0.0167


var once = false


func shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if not rigid.logical_position:
		if rigid.has_method("on_despawn"):
			rigid.on_despawn()
		return
	
	if CollisionLogic.get_logical_position(body_rid, body).y >= rigid.logical_position.y + 3.0:
		last_bounce_position = rigid.position.y
		bounce_velocity = -2.2
		if not once and rigid.has_method("on_first_bounce"):
			rigid.on_first_bounce()
			once = true
		if rigid.has_method("on_bounce"):
			rigid.on_bounce()
	else:
		if rigid.has_method("on_despawn"):
			rigid.on_despawn()
