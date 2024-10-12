extends AnimatableBody2D


@export var call_when_hit: String = "on_event_block_hit"

@onready var animated_sprite: AnimatedSprite2D = find_child("animated_sprite")
@onready var sprite: Sprite2D = find_child("sprite")

@onready var animation: AnimationPlayer = $animation
@onready var bump: Area2D = $bump
@onready var bump_sound: AudioStreamPlayer2D = $channels/bump_sound
@onready var switch_sound: AudioStreamPlayer2D = $channels/switch_sound

@onready var boss = get_parent()

var hit_times: int = 0


func _ready() -> void:
	bump.body_entered.connect(on_bump)

func on_bump(body: Node2D) -> void:
	if body.has_method("block_bumper"):
		bump_sound.play()
		switch_sound.play()
		hit()


func hit() -> void:
	hit_times += 1
	animation.stop()
	
	if boss.has_method(call_when_hit):
		boss.call(call_when_hit, hit_times)
	
	if animated_sprite:
		animation.play("animated_bump")
	else:
		animation.play("bumped")
