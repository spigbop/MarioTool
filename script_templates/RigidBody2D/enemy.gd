extends RigidBody2D


#@onready var patrol_ai: Node = $patrol_ai
#@onready var stompable_ai: Node = $stompable_ai


# called when entering the screen
# make sure enemies have 0.0 gravity scaling initially
func enter_spawn_area() -> void:
	gravity_scale = 1.0
	# This is where ais should spawn
	#patrol_ai.spawn()
	#stompable_ai.spawn()

# called when exiting the screen
# best used with projectile throwers to reduce lag.
func exit_spawn_area() -> void:
	pass

# called when entering the death barrier.
# the death barrier kills enemies as well as players.
func enter_death_barrier() -> void:
	queue_free()

# -------------------------
# stompable_ai.gd Functions
# -------------------------
# .spawn() -> void
# - Starts ai process

# called when stomped by a 'stomper' (player)
func on_stomp() -> void:
	pass

# called when entering in contact (the top doesnt count)
# most enemies hurt once in contact
func on_contact(body) -> void:
	if body.has_method("hurt"):
		body.hurt()

# called when collided with a 'stomper' (player)
# direction doesnt matter can be used for combining on_stomp and on_contact
# best suited for SMW shelless koopas
func on_kick(body_position, stomped) -> void:
	pass

# ---------------------------
# generic_defeat.gd Functions
# ---------------------------
# .generic_defeat(death_cause, effect_speed) -> void
# - Kills the target with flying effect

# called after death effects are played and before queue_free()
func on_death(cause, effect_speed) -> void:
	queue_free()
