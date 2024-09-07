extends Area2D


@export var subject: PackedScene = null
enum PIPE_DIRECTION { NORTH, SOUTH, WEST, EAST, NONE }
@export var pipe_direction: PIPE_DIRECTION = PIPE_DIRECTION.NORTH
@export var player_can_disable = true

@onready var timer: Timer = $timer

var inhibited = false
var spawn_asap = false


func spawn_subject() -> Node2D:
	var inst = subject.instantiate()
	if pipe_direction == PIPE_DIRECTION.NORTH:
		if inst.has_method("on_appear"):
			inst.position = position
			add_sibling(inst)
			inst.on_appear()
		else:
			inst.queue_free()
			DummySpawner.spawn_from_pipe(self, subject.resource_path, position)
	return inst


func enter_spawn_area() -> void:
	if timer.is_stopped():
		timer.start()

func exit_spawn_area() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	if player_can_disable and inhibited:
		spawn_asap = true
		timer.stop()
	else:
		spawn_subject()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		inhibited = true

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("hurt"):
		if spawn_asap:
			spawn_asap = false
			spawn_subject()
		inhibited = false
		timer.start()
