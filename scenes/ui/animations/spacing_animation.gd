extends Node


@export var increment: float = -1.0
@export var max_value: float = 300.0
@export var min_value: float = 0.0
@export var bouncing: int = 0
@onready var control = find_child("text")


func _physics_process(_delta: float) -> void:
	if bouncing > -1:
		if control.spacing.x > max_value:
			control.spacing.x = max_value
			increment *= -0.5
		if control.spacing.x < min_value:
			control.spacing.x = min_value
			max_value /= 4.0
			increment *= -0.5
			bouncing -= 1
	else:
		set_physics_process(false)
	control.spacing.x += increment
