extends RigidBody2D


@export var direction: MarioTool.DIRECTION_H = MarioTool.DIRECTION_H.EAST

@onready var patrol_ai: Patrolling = $patrol_ai
@onready var stompable_ai: Stompable = $stompable_ai
@onready var sprite: Sprite2D = $sprite


func enter_spawn_area() -> void:
	patrol_ai.spawn()
	stompable_ai.spawn()
	
func enter_death_barrier() -> void:
	queue_free()


func on_stomp() -> void:
	var stomp = load("res://scenes/effects/goomba_stomp_effect.tscn")
	var inst = stomp.instantiate()
	inst.position = position
	add_sibling(inst)
	queue_free()

func on_contact(body) -> void:
	if body.has_method("hurt"):
		body.hurt()
