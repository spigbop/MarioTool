extends RigidBody2D


@export var tier = 1

@onready var animation: AnimationPlayer = $animation


func appear() -> void:
	animation.play("appear")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("powerup_picker"):
		body.powerup_picker(tier)
		queue_free()
