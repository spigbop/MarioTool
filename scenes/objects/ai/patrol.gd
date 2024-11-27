extends AI
class_name Patrolling


@export var turnbox_name: String = "turn"
@export var hitbox_name: String = "hitbox"
@export var speed = 1.0 # +: to right -: to left
@export var autostart = false
@export var can_fly = false
@export var flip_when_turned = false

var shape_offset = 3.0
var logical_position = null
@onready var rigid = get_parent()


func _ready():
	set_physics_process(false)
	var turnbox = rigid.find_child(turnbox_name)
	if turnbox:
		turnbox.body_shape_entered.connect(turn)
	
	var hitbox = rigid.find_child(hitbox_name)
	if hitbox:
		shape_offset = hitbox.get_node("shape").shape.size.y / 2.0
	
	if autostart:
		spawn()

var spawned = false

func spawn():
	if not spawned:
		spawned = true
		if "direction" in rigid:
			apply_turn_logic(rigid.direction)
		set_physics_process(true)
		# unhides from pipe
		if rigid.z_index < 15:
			rigid.z_index = 15
		if "gravity_scale" in rigid and rigid.gravity_scale == 0.0 and not can_fly:
			rigid.gravity_scale = 1.0

func _physics_process(_delta: float) -> void:
	logical_position = rigid.position
	rigid.position.x += speed

func turn(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.has_method("enter_spawn_area") or logical_position and not logical_position.y - CollisionLogic.get_logical_position(body_rid, body).y >= 8.0 + shape_offset:
		force_turn()


func force_turn() -> void:
	speed *= -1.0
	if flip_when_turned:
		rigid.get_node("sprite").flip_h = speed < 0
	if rigid.has_method("on_turn"):
		rigid.on_turn()


func apply_turn_logic(direction: MarioTool.DIRECTION_H) -> void:
	if direction == MarioTool.DIRECTION_H.WEST or direction == MarioTool.DIRECTION_H.PLAYER and is_instance_valid(MarioTool.get_player()) and MarioTool.get_player().position.x - rigid.position.x < 0:
		speed = -abs(speed)
	elif direction == MarioTool.DIRECTION_H.EAST or direction == MarioTool.DIRECTION_H.PLAYER and is_instance_valid(MarioTool.get_player()) and MarioTool.get_player().position.x - rigid.position.x > 0:
		speed = abs(speed)
	
	if flip_when_turned:
		rigid.get_node("sprite").flip_h = speed < 0
