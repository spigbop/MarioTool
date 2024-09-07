extends Node2D


class_name DummySpawner


static func spawn_from_pipe(caller_node: Node2D, scene_path: String, effect_position: Vector2, direction: MarioTool.DIRECTION = MarioTool.DIRECTION.NORTH, sprite_offset: float = 0.0, duration: float = 0.5, callback = null) -> void:
	# load object into memory
	var scene = load(scene_path)
	var node: Node2D = scene.instantiate()
	node.position = effect_position
	
	# spawn the dummy
	var dummy = load("res://scenes/effects/dummy/dummy.tscn")
	var dummy_node = dummy.instantiate()
	dummy_node.position = effect_position
	caller_node.add_sibling(dummy_node)
	
	var direction_vector
	
	if direction == MarioTool.DIRECTION.NORTH:
		direction_vector = Vector2(0.0, -1.0)
	elif direction == MarioTool.DIRECTION.SOUTH:
		direction_vector = Vector2(0.0, 1.0)
	elif direction == MarioTool.DIRECTION.WEST:
		direction_vector = Vector2(-1.0, 0.0)
	elif direction == MarioTool.DIRECTION.EAST:
		direction_vector = Vector2(1.0, 0.0)
	
	var sprite = node.get_node("sprite")
	
	var texture
	
	if "sprite_frames" in sprite:
		texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	else:
		texture = sprite.texture
	
	dummy_node.setup(duration, direction_vector, texture, sprite_offset, node, caller_node, callback)
