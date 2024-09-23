extends RigidBody2D


@export var shell_color_index: int = 1

@onready var patrol_ai: Node = $patrol_ai
@onready var stompable_ai: Node = $stompable_ai
@onready var sprite: AnimatedSprite2D = $sprite


func enter_spawn_area() -> void:
	sprite.speed_scale = 1.0
	patrol_ai.spawn()
	stompable_ai.spawn()

func exit_spawn_area() -> void:
	pass


func on_stomp() -> void:
	var shell = load("res://scenes/objects/enemies/shell.tscn")
	var inst = shell.instantiate()
	inst.position = position
	add_sibling(inst)
	inst.set_shell_color(shell_color_index)
	queue_free()

func on_contact(body) -> void:
	if body.has_method("hurt"):
		body.hurt()
