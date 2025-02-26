extends RigidBody2D


@export var direction: MarioTool.DIRECTION_H = MarioTool.DIRECTION_H.EAST

@export var shell_color_index: int = 1

@onready var patrol_ai: Patrolling = $patrol_ai
@onready var stompable_ai: Stompable = $stompable_ai
@onready var generic_defeat_ai: Defeatable = $generic_defeat_ai

@onready var sprite: AnimatedSprite2D = $sprite


func enter_spawn_area() -> void:
	patrol_ai.spawn()
	stompable_ai.spawn()

func enter_liquid(viscosity: float, liquid_material: int) -> void:
	if liquid_material != 0:
		generic_defeat_ai.generic_defeat("liquid", patrol_ai.speed)
	patrol_ai.speed *= (1.0 - viscosity)

func exit_liquid(viscosity: float, _liquid_material: int) -> void:
	patrol_ai.speed /= (1.0 - viscosity)

func enter_death_barrier() -> void:
	queue_free()


func on_stomp() -> void:
	var shell = load("res://scenes/objects/enemies/" + Mathx.bool_gate(shell_color_index == 2, "buzzy_beetle_", "") + "shell.tscn")
	var inst = shell.instantiate()
	inst.position = position
	inst.has_koopa = true
	inst.shell_color_index = shell_color_index
	call_deferred("add_sibling", inst) 
	queue_free()

func on_contact(body) -> void:
	if body.has_method("hurt"):
		body.hurt()
