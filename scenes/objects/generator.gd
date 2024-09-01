extends Marker2D


@export var subject: PackedScene = null
enum PIPE_DIRECTION { NORTH, SOUTH, WEST, EAST, NONE }
@export var pipe_direction: PIPE_DIRECTION = PIPE_DIRECTION.NORTH
@export var player_can_disable = true
@onready var timer: Timer = $timer

var inhibited = false
var spawn_asap = false


func spawn_subject() -> Node2D:
	var inst = subject.instantiate()
	inst.set_deferred("position", position)
	add_sibling(inst)
	if pipe_direction == PIPE_DIRECTION.NORTH and inst.has_method("appear"):
		inst.appear()
	return inst


func _on_timer_timeout() -> void:
	if player_can_disable and inhibited:
		spawn_asap = true
		timer.stop()
	else:
		spawn_subject()


func _on_inhibit_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		inhibited = true

func _on_inhibit_body_exited(body: Node2D) -> void:
	if body.has_method("hurt"):
		if spawn_asap:
			spawn_asap = false
			spawn_subject()
		inhibited = false
		timer.start()
