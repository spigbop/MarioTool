extends AnimatableBody2D


@export var breakable: bool = true
@export var contents: PackedScene = null
@export var count: int = 1


@onready var sprite: Sprite2D = $sprite
@onready var animation: AnimationPlayer = $animation
@onready var bump_sound: AudioStreamPlayer2D = $channels/bump_sound
@onready var contents_sound: AudioStreamPlayer2D = $channels/contents_sound


var emptied = false
@onready var current_count = count
const EMPTY_BLOCK_ATLAS = preload("res://scenes/tiles/resources/empty_block_atlas.tres")
const QUESTION_MARK_BLOCK = preload("res://scenes/tiles/resources/question_mark_block.tres")


func _on_bump_body_entered(body: Node2D) -> void:
	if body.has_method("block_bumper"):
		bump_sound.play()
		if emptied:
			return
		if body.has_method("spinning_shell"):
			hit(1, null)
		else:
			hit(body.powerup, body)

func hit(ptier, _body):
	if contents:
		# box empty
		current_count -= 1
		animation.stop()
		
		if current_count == 0:
			emptied = true
			if $animated_sprite:
				$animated_sprite.queue_free()
			sprite.texture = EMPTY_BLOCK_ATLAS
			animation.play("bumped")
		else:
			if $animated_sprite:
				animation.play("animated_bump")
			else:
				animation.play("bumped")
		
		# powerup generation
		var content = contents.instantiate()
		content.position = position
		content.position.y -= 16.0
		add_sibling(content)
		if content.has_method("appear"):
			content.appear(ptier)
		if not content.has_method("collect"):
			contents_sound.play()
	else:
		if ptier > 0 and breakable:
			var effect = load("res://scenes/effects/brick_breaking_effect.tscn")
			var inst = effect.instantiate()
			inst.position = position
			add_sibling(inst)
			queue_free()
		else:
			animation.stop()
			animation.play("bumped")


func coin_popper():
	pass
