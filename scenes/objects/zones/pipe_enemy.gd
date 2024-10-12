extends Area2D


@export var subject: PackedScene
var enemy: Node2D = null


func _ready() -> void:
	body_entered.connect(on_enter)
	body_exited.connect(on_exit)


func enter_spawn_area() -> void:
	enemy = subject.instantiate()
	enemy.boss = self
	enemy.position = position
	call_deferred("add_sibling", enemy)
	enemy.call_deferred("enter_spawn_area")


func on_enter(body: Node2D) -> void:
	inhibit_enemy(body, true)

func on_exit(body: Node2D) -> void:
	inhibit_enemy(body, false)


func inhibit_enemy(body: Node2D, inhibited: bool = false) -> void:
	if not is_instance_valid(enemy):
		queue_free()
		return
	if "inhibited" in enemy and body.has_method("hurt"):
		enemy.inhibited = inhibited
