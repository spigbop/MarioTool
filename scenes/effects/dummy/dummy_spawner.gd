extends Node2D


class_name DummySpawner


static func spawn_from_pipe(caller_node: Node2D, scene_path, effect_position: Vector2, already_spawned = false, direction: MarioTool.DIRECTION = MarioTool.DIRECTION.NORTH, sprite_offset: float = 0.0, duration: float = 0.5, callback = null) -> Node2D:
	# load object into memory
	var node = null
	if not already_spawned:
		var scene = load(scene_path)
		node = scene.instantiate()
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
	
	var texture = null
	if typeof(scene_path) == 24:
		texture = scene_path
	elif node:
		var sprite = node.get_node("sprite")
		if "sprite_frames" in sprite:
			texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
		else:
			texture = sprite.texture
	else:
		texture = load(scene_path)
	
	dummy_node.setup(duration, direction_vector, texture, sprite_offset, node, caller_node, callback)
	
	return dummy_node
