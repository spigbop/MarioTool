extends RigidBody2D


@export var tier = 1
@export var needs_super = false
@onready var animation: AnimationPlayer = $animation
@onready var ai: Node = $ai


func enter_spawn_area() -> void:
	if not animation.current_animation == "appear" and ai:
		ai.spawn()


func appear(powerup_tier = null) -> void:
	if needs_super and powerup_tier == 0:
		var asset = load("res://scenes/objects/powerups/super_mushroom.tscn")
		var mushroom = asset.instantiate()
		mushroom.position = position
		add_sibling(mushroom)
		mushroom.appear()
		queue_free()
	else:
		animation.play("appear")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("powerup_picker"):
		body.powerup_picker(tier)
		queue_free()

func _on_turn_body_entered(_body: Node2D) -> void:
	ai.turn()
