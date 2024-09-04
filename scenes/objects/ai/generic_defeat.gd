extends Node


@onready var rigid: RigidBody2D = get_parent()
@onready var sprite = get_parent().get_node("sprite")

@export var hitbox_name = "hitbox"
@export var fireballable = true
@export var shellable = true
@export var starmanable = true


func generic_defeat(speed) -> void:
	# first effect
	var star_struck_effect = load("res://scenes/effects/star_struck_effect.tscn")
	var effect_0 = star_struck_effect.instantiate()
	effect_0.position = rigid.position
	rigid.add_sibling(effect_0)
	# second effect
	var fallen_foe_effect = load("res://scenes/effects/fallen_effect.tscn")
	var effect_1 = fallen_foe_effect.instantiate()
	effect_1.position = rigid.position
	effect_1.velocity.x = speed
	var effect_1_sprite = effect_1.get_node("sprite")
	
	if "speed_scale" in sprite:
		effect_1_sprite.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	else:
		effect_1_sprite.texture = sprite.texture
	
	effect_1_sprite.flip_v = true
	rigid.add_sibling(effect_1)
	rigid.queue_free()


func _ready() -> void:
	rigid.get_node(hitbox_name).area_entered.connect(area_entered)

func area_entered(area: Area2D) -> void:
	if fireballable and area.has_method("fireball"):
		area.fireball()
		generic_defeat(area.direction)
		return
	
	elif starmanable and area.has_method("starman"):
		area.starman()
		generic_defeat(area.direction)
		return
	
	elif shellable and area.get_parent().has_method("get_shell_speed") and area.get_parent().kicked == true:
		generic_defeat(-area.get_parent().get_shell_speed() / 3.0)
		return