extends RigidBody2D


@export var velocity: Vector2 = Vector2(.0, .6)
@export var chomp_time = 2.8

@onready var stompable_ai: Node = $stompable_ai
@onready var sprite: AnimatedSprite2D = $sprite

var inside_pos_y = null
var outside_pos_y = null

var boss = null


func _ready() -> void:
	set_physics_process(false)
	if boss:
		position.y += sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame).get_height() + 1.0
	inside_pos_y = position.y
	outside_pos_y = position.y - sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame).get_height() - .5

func enter_spawn_area() -> void:
	set_physics_process(true)
	stompable_ai.spawn()

func exit_spawn_area() -> void:
	set_physics_process(false)


func on_kick(_log_pos, body, _aerial) -> void:
	if body.has_method("hurt"):
		body.hurt()


var inhibited = false
var inside = false
var cooldown = .0
func _physics_process(_delta: float) -> void:
	cooldown -= 0.05
	if cooldown > 0 or inside and inhibited:
		return
	
	inside = false
	
	if position.y <= outside_pos_y:
		position.y = outside_pos_y
		velocity.y = abs(velocity.y)
		cooldown = chomp_time
	elif position.y >= inside_pos_y:
		position.y = inside_pos_y
		velocity.y = -abs(velocity.y)
		cooldown = chomp_time
		inside = true
	
	position += velocity
