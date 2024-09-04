extends Node2D


@onready var sprite: Sprite2D = $sprite
@onready var timer: Timer = $timer

var velocity = Vector2(0.0, -0.375)

var node
var caller
var callback


func add_scene() -> void:
	if is_instance_valid(caller):
		caller.add_sibling(node)
	else:
		add_sibling(node)
	if callback and caller.has_method(callback):
		caller.call(callback)
	queue_free()


func setup(duration, init_direction, init_texture, sprite_offset, a: Node2D, b: Node2D, c = null) -> void:
	sprite.texture = init_texture
	sprite.position.y = sprite_offset
	
	node     = a
	caller   = b
	callback = c
	
	timer.wait_time = duration
	timer.timeout.connect(add_scene)
	timer.start()
	
	position += init_direction * -12.0
	velocity *= 0.5
	velocity /= duration


func _physics_process(_delta: float) -> void:
	position += velocity
