extends Area2D


@export var subject: PackedScene = null
@export var pipe_direction: MarioTool.DIRECTION = MarioTool.DIRECTION.NORTH
@export var spawn_timer: float = 3.0
@export var player_can_disable = true

@onready var timer: Timer = $timer

var inhibited = false
var spawn_asap = false


func _ready() -> void:
	timer.wait_time = spawn_timer
	timer.timeout.connect(on_timeout)
	body_entered.connect(on_enter)
	body_exited.connect(on_exit)

func spawn_subject() -> Node2D:
	var inst = subject.instantiate()
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

func on_timeout() -> void:
	if player_can_disable and inhibited:
		spawn_asap = true
		timer.stop()
	else:
		spawn_subject()


func on_enter(body: Node2D) -> void:
	if body.has_method("hurt"):
		inhibited = true

func on_exit(body: Node2D) -> void:
	if body.has_method("hurt"):
		if spawn_asap:
			spawn_asap = false
			spawn_subject()
		inhibited = false
		timer.start()
