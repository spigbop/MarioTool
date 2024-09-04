extends RigidBody2D


@onready var patrol_ai: Node = $patrol_ai
@onready var sprite: AnimatedSprite2D = $sprite

@onready var animation: AnimationPlayer = $animation

var kicked = false


# spawn_area.gd
func enter_spawn_area() -> void:
	gravity_scale = 1.0

func exit_spawn_area() -> void:
	pass


# stompable_ai
func on_kick(impact, _aerial) -> void:
	kicked = not kicked
	var multiplier = 1.0
	if kicked:
		sprite.speed_scale = 1.0
	else:
		sprite.speed_scale = 0.0
		multiplier = 0.0
	
	var star_struck_effect = load("res://scenes/effects/star_struck_effect.tscn")
	var effect_0 = star_struck_effect.instantiate()
	effect_0.position = position
	add_sibling(effect_0)
	
	if position.x - impact.x < 0:
		multiplier *= -1.0
	
	patrol_ai.current_speed = 4.2 * multiplier

func on_contact(body) -> void:
	if kicked and body.has_method("hurt"):
		body.hurt()


# blocks & generators
func appear():
	animation.play("appear")


# Methods
const SHELL_COLORS = [ 
	preload("res://scenes/objects/enemies/resources/green_shell.tres"),
	preload("res://scenes/objects/enemies/resources/red_shell.tres") ]

func set_shell_color(color_index: int) -> void:
	sprite.sprite_frames = SHELL_COLORS[color_index]
	sprite.play()

func get_shell_speed() -> float:
	return patrol_ai.current_speed
