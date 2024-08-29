extends RigidBody2D


@onready var ai: Node = $patrol_ai
@export var goes_right = false


func enter_spawn_area() -> void:
	gravity_scale = 1.0
	if goes_right:
		ai.speed = -abs(ai.speed)
	else:
		ai.speed = abs(ai.speed)
	ai.spawn()


func _on_turn_body_entered(body: Node2D) -> void:
	ai.turn()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("fireball"):
		body.fireball()
		# spawn effect
		queue_free()
	if body.position.y < position.y - 6.0:
		if body.has_method("stomper"):
			var stomp = load("res://scenes/effects/goomba_stomp_effect.tscn")
			var inst = stomp.instantiate()
			inst.position = position
			add_sibling(inst)
			if body.has_method("force_jump"):
				body.force_jump()
			queue_free()
	else:
		if body.has_method("hurt"):
			body.hurt()
