extends AI
class_name Patrolling


@export var turnbox_name = "turn"
@export var hitbox_name = "hitbox"
@export var speed = 1.0 # +: to right -: to left
@export var autostart = false
@export var flip_when_turned = false

var shape_offset = 3.0
var logical_position = null
@onready var rigid = get_parent()


func _ready():
	set_process(false)
	var turnbox = rigid.get_node(turnbox_name)
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
		set_process(true)
		# unhides from pipe
		if rigid.z_index < 15:
			rigid.z_index = 15
		if "gravity_scale" in rigid and rigid.gravity_scale == 0.0:
			rigid.gravity_scale = 1.0

func _physics_process(_delta: float) -> void:
	logical_position = rigid.position
	rigid.position.x += speed

func turn(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if not logical_position.y - CollisionLogic.get_logical_position(body_rid, body).y >= 8.0 + shape_offset:
		speed *= -1.0
		if flip_when_turned:
			rigid.get_node("sprite").flip_h = speed < 0
		if rigid.has_method("on_turn"):
			rigid.on_turn()
