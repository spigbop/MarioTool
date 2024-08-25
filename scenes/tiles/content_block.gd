extends AnimatableBody2D


@export var breakable: bool = true
@export var contents: PackedScene = null


@onready var sprite: Sprite2D = $sprite
@onready var animation: AnimationPlayer = $animation
@onready var bump_sound: AudioStreamPlayer2D = $channels/bump_sound
@onready var contents_sound: AudioStreamPlayer2D = $channels/contents_sound


var emptied = false
const EMPTY_BLOCK_ATLAS = preload("res://scenes/tiles/resources/empty_block_atlas.tres")


func _on_bump_body_entered(body: Node2D) -> void:
	if body.has_method("block_bumper"):
		bump_sound.play()
		if emptied:
			return
		if contents:
			emptied = true
			sprite.texture = EMPTY_BLOCK_ATLAS
			animation.play("bumped")
			contents_sound.play()
		else:
			if body.powerup > 0:
				return
			else:
				animation.play("bumped")
