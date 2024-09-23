extends RigidBody2D


@onready var patrol_ai: Node = $patrol_ai
@onready var stompable_ai: Node = $stompable_ai
@onready var generic_defeat_ai: Node = $generic_defeat_ai

@onready var bullet_sound: AudioStreamPlayer2D = $bullet_sound


func enter_spawn_area() -> void:
	if not patrol_ai.spawned:
		bullet_sound.play()
	patrol_ai.spawn()
	stompable_ai.spawn()
	if not despawn_interval.is_stopped():
		despawn_interval.stop()

@onready var despawn_interval: Timer = $despawn_interval

func exit_spawn_area() -> void:
	despawn_interval.timeout.connect(despawn_interval_timeout)
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
