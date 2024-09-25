extends RigidBody2D


@onready var patrol_ai: Node = $patrol_ai
@onready var stompable_ai: Node = $stompable_ai
@onready var sprite: AnimatedSprite2D = $sprite

@onready var animation: AnimationPlayer = $animation

var has_koopa = false
var kicked = false


func enter_spawn_area() -> void:
	patrol_ai.spawn()
	stompable_ai.spawn()


var skip_kick = false

func on_kick(impact, _body, _aerial) -> void:
	if skip_kick:
		skip_kick = false
		return
	
	kicked = not kicked
	var multiplier = 1.0
	if kicked:
		sprite.speed_scale = 1.0
		
		set_collision_layer_value(4, false)
		set_collision_layer_value(5, true)
		set_collision_mask_value(4, false)
		set_collision_mask_value(5, true)
	else:
		sprite.speed_scale = 0.0
		multiplier = 0.0
		
		set_collision_layer_value(4, true)
		set_collision_layer_value(5, false)
		set_collision_mask_value(4, true)
		set_collision_mask_value(5, false)
	
	var star_struck_effect = load("res://scenes/effects/star_struck_effect.tscn")
	var effect_0 = star_struck_effect.instantiate()
	effect_0.position = position
	add_sibling(effect_0)
	
	if position.x - impact.x < 0:
		multiplier *= -1.0
	
	patrol_ai.speed = 4.2 * multiplier

func on_contact(body) -> void:
	if kicked and body.has_method("hurt"):
		skip_kick = true
		body.hurt()


const SHELL_COLORS = [ 
	preload("res://scenes/objects/enemies/resources/green_shell.tres"),
	preload("res://scenes/objects/enemies/resources/red_shell.tres") ]

func set_shell_color(color_index: int) -> void:
	sprite.sprite_frames = SHELL_COLORS[color_index]
	sprite.play()

func get_shell_speed() -> float:
	return patrol_ai.speed
