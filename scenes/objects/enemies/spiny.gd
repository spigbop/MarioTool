extends RigidBody2D


@export var direction: MarioTool.DIRECTION_H = MarioTool.DIRECTION_H.EAST

@onready var patrol_ai: Node = $patrol_ai
@onready var stompable_ai: Node = $stompable_ai


func enter_spawn_area() -> void:
	patrol_ai.spawn()
	stompable_ai.spawn()

func enter_death_barrier() -> void:
	queue_free()


func on_kick(_log_pos, body, _aerial) -> void:
	if body.has_method("hurt"):
		body.hurt()
