extends RigidBody2D


@onready var ai: Node = $patrol_ai
@onready var sprite: Sprite2D = $sprite
@export var goes_right = false

@onready var animation: AnimationPlayer = $animation


func enter_spawn_area() -> void:
	gravity_scale = 1.0
	if goes_right:
		ai.speed = -abs(ai.speed)
	else:
		ai.speed = abs(ai.speed)
	if not animation.current_animation == "appear":
		ai.spawn()

func exit_spawn_area() -> void:
	queue_free() # change this to freeze later

func _on_turn_body_entered(body: Node2D) -> void:
	ai.turn()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.logical_position.y < position.y - 8.0:
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


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("fireball"):
		area.fireball()
		# first effect
		var star_struck_effect = load("res://scenes/effects/star_struck_effect.tscn")
		var effect_0 = star_struck_effect.instantiate()
		effect_0.position = position
		add_sibling(effect_0)
		# second effect
		var fallen_foe_effect = load("res://scenes/effects/fallen_effect.tscn")
		var effect_1 = fallen_foe_effect.instantiate()
		effect_1.position = position
		effect_1.velocity.x = area.direction
		var effect_1_sprite = effect_1.get_node("sprite")
		effect_1_sprite.texture = sprite.texture
		effect_1_sprite.flip_v = true
		add_sibling(effect_1)
		queue_free()

func appear():
	animation.play("appear")
