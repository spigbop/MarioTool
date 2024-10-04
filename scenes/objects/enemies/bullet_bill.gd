extends RigidBody2D


@export var direction: MarioTool.DIRECTION_H = MarioTool.DIRECTION_H.PLAYER

@onready var patrol_ai: Patrolling = $patrol_ai
@onready var stompable_ai: Stompable = $stompable_ai
@onready var generic_defeat_ai: Defeatable = $generic_defeat_ai

@onready var bullet_sound: AudioStreamPlayer2D = $bullet_sound


func enter_spawn_area() -> void:
	if not patrol_ai.spawned:
		bullet_sound.play()
	patrol_ai.spawn()
	stompable_ai.spawn()
	if despawn_interval and not despawn_interval.is_stopped():
		despawn_interval.stop()

@onready var despawn_interval: Timer = $despawn_interval
var interval_connected: bool = false

func exit_spawn_area() -> void:
	if is_instance_valid(despawn_interval) and despawn_interval.is_inside_tree():
		if not interval_connected:
			despawn_interval.timeout.connect(despawn_interval_timeout)
			interval_connected = true
		despawn_interval.start()

func despawn_interval_timeout() -> void:
	queue_free()

func enter_death_barrier() -> void:
	queue_free()


func on_stomp() -> void:
	generic_defeat_ai.generic_defeat("stomp", patrol_ai.speed)

func on_contact(body) -> void:
	if body.has_method("hurt"):
		body.hurt()


func on_appear() -> void:
	pass
