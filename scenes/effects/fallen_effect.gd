extends Node2D


@export var velocity = Vector2(0.0, -2.2)


func _physics_process(delta: float) -> void:
	position += velocity
	velocity.y += 5.5 * delta
