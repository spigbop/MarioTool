extends Node


@export var speed = 1.0 # +: to right -: to left
@export var autostart = false
var current_speed = 0.0
var rigid = null


func _ready():
	rigid = get_parent()
	if autostart:
		spawn()

func spawn():
	current_speed = speed

func _physics_process(_delta: float) -> void:
	rigid.position.x += current_speed

func turn() -> void:
	current_speed *= -1.0
