extends Node


@export var speed = 1.0 # +: to right -: to left
@export var autostart = false
var current_speed = 0.0


func _ready():
	if autostart:
		spawn()

func spawn():
	current_speed = speed

func _physics_process(_delta: float) -> void:
	get_parent().position.x += current_speed

func _on_body_shape_entered():
	current_speed *= -1.0
