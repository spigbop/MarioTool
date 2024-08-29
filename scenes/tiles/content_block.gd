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
		if body.has_method("spinning_shell"):
			hit(1, null)
		else:
			hit(body.powerup, body)

func hit(ptier, _body):
	if contents:
		emptied = true
		sprite.texture = EMPTY_BLOCK_ATLAS
		# powerup generation
		var content = contents.instantiate()
		content.position = position
		content.position.y -= 16.0
		add_sibling(content)
		if content.has_method("appear"):
			content.appear()
		animation.stop()
		animation.play("bumped")
		contents_sound.play()
	else:
		if ptier > 0:
			var effect = load("res://scenes/effects/brick_breaking_effect.tscn")
			var inst = effect.instantiate()
			inst.position = position
			add_sibling(inst)
			queue_free()
		else:
			animation.stop()
			animation.play("bumped")


@onready var collect_sound: AudioStreamPlayer2D = $channels/collect_sound

func coin_picker():
	collect_sound.play()
