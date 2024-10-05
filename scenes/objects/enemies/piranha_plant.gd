extends RigidBody2D


@export var speed = .6
@export var chomp_time = 2.0

@onready var stompable_ai: Node = $stompable_ai
@onready var sprite: AnimatedSprite2D = $sprite

@onready var inside_pos_y = position.y
@onready var outside_pos_y = position.y - sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame).get_height()


func _ready() -> void:
	set_physics_process(false)

func enter_spawn_area() -> void:
	set_physics_process(true)
	stompable_ai.spawn()

func exit_spawn_area() -> void:
	set_physics_process(false)


func on_kick(_log_pos, body, _aerial) -> void:
	if body.has_method("hurt"):
		body.hurt()


var cooldown = .0
func _physics_process(_delta: float) -> void:
	cooldown -= 0.05
	if cooldown > 0:
		return
	
	if position.y <= outside_pos_y:
		position.y = outside_pos_y
		speed *= -1.0
		cooldown = chomp_time
	elif position.y >= inside_pos_y:
		position.y = inside_pos_y
		speed *= -1.0
		cooldown = chomp_time
	
	position.y += speed
