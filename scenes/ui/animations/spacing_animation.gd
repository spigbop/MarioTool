extends Node


@export var increment = -1.0
@export var max_value = 300.0
@export var min_value = 0.0
@onready var control = find_child("text")


func _physics_process(_delta: float) -> void:
	control.spacing = clamp(control.spacing + increment, min_value, max_value)
