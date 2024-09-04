extends RigidBody2D


@onready var patrol_ai: Node = $patrol_ai
@onready var stompable_ai: Node = $stompable_ai
@onready var sprite: Sprite2D = $sprite


# spawn_area.gd
func enter_spawn_area() -> void:
	gravity_scale = 1.0
	patrol_ai.spawn()
	stompable_ai.spawn()

func exit_spawn_area() -> void:
	pass


# stompable_ai
func on_stomp() -> void:
	var stomp = load("res://scenes/effects/goomba_stomp_effect.tscn")
	var inst = stomp.instantiate()
	inst.position = position
	add_sibling(inst)
	queue_free()

func on_contact(body) -> void:
	if body.has_method("hurt"):
		body.hurt()
