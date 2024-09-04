extends Node


@export var turnbox_name = "turn"
@export var speed = 1.0 # +: to right -: to left
@export var autostart = false
@export var flip_when_turned = false

var current_speed = 0.0
@onready var rigid = get_parent()


func _ready():
	var turnbox = rigid.get_node(turnbox_name)
	if turnbox:
		turnbox.body_entered.connect(turn)
	
	if autostart:
		spawn()

func spawn():
	current_speed = speed
	# unhides from pipe
	if rigid.z_index < 15:
		rigid.z_index = 15
	if "gravity_scale" in rigid and rigid.gravity_scale == 0.0:
		rigid.gravity_scale = 1.0

func _physics_process(_delta: float) -> void:
	rigid.position.x += current_speed

func turn(_body: Node2D) -> void:
	current_speed *= -1.0
	if flip_when_turned:
		rigid.get_node("sprite").flip_h = current_speed < 0
