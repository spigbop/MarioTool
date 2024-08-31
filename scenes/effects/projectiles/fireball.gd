extends Area2D


const SPEED = 3.65
const BOUNCE_SPEED = 1.6

var player = null
var direction = 1.0

var bounce_velocity = 1.0
var last_bounce_position = 0.0

var logical_position = null


func _physics_process(delta: float) -> void:
	logical_position = position
	
	position.y += bounce_velocity * BOUNCE_SPEED # accel = 9.8
	position.x += direction * SPEED # accel = 0
	
	bounce_velocity += BOUNCE_SPEED * 6.0 * delta

var once = false


func fireball() -> void:
	despawn()

func exit_spawn_area() -> void:
	despawn(false)

func despawn(play_effect = true) -> void:
	player.projectiles = clamp(player.projectiles - 1, 0, 2)
	if not once:
		player.is_throwing = false
	if play_effect:
		var fireball_effect = load("res://scenes/effects/fireball_effect.tscn")
		var effect = fireball_effect.instantiate()
		effect.position = position
		add_sibling(effect)
	queue_free()




func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not logical_position:
		despawn()
		return
	
	var collider
	
	if body.has_method("get_collision_layer"):
		if body.get_collision_layer() == 1:
			collider = body.position
		else:
			return
	elif body.has_method("get_coords_for_body_rid"):
		var coords = body.get_coords_for_body_rid(body_rid)
		var tsize = body.tile_set.tile_size
		collider = Vector2(body.position.x + coords.x * tsize.x, body.position.y + coords.y * tsize.y)
	else:
		return
	
	if collider.y > logical_position.y + 4.0:
		last_bounce_position = position.y
		bounce_velocity = -2.2
		if not once:
			player.is_throwing = false
		once = true
	else:
		despawn()
