extends Node


@export var tier = 1
@onready var animation: AnimationPlayer = $animation
@onready var ai: Node = $ai


func enter_spawn_area() -> void:
	if not animation.current_animation == "appear":
		ai.spawn()


func appear() -> void:
	animation.play("appear")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("powerup_picker"):
		body.powerup_picker(tier)
		queue_free()

func _on_turn_body_entered(body: Node2D) -> void:
	ai.turn()
