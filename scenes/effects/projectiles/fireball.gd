extends Area2D


@onready var bounce_ai: Node = $bounce_ai

var player = null
var direction = 1.0

var logical_position = null


func enter_spawn_area() -> void:
	bounce_ai.direction = direction
	bounce_ai.spawn()


func exit_spawn_area() -> void:
	on_despawn(false)


func on_despawn(play_effect = true) -> void:
	player.projectiles.erase(get_node("."))
	player.is_throwing = false
	if play_effect:
		var fireball_effect = load("res://scenes/effects/fireball_effect.tscn")
		var effect = fireball_effect.instantiate()
		effect.position = position
		add_sibling(effect)
	queue_free()


func on_first_bounce() -> void:
	player.is_throwing = false


func fireball() -> void:
	on_despawn()
