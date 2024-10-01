class_name CollisionLogic


static func get_logical_position(body_rid, body: Node2D) -> Vector2:
	var position = body.position
	
	# for objects with precalculated logical positions
	if "logical_position" in body:
		position = body.logical_position
	
	# for objects with calculatable logical positions
	elif "velocity" in body:
		position = body.position - body.velocity
	
	# for rigid/static/animatable bodies
	elif body.has_method("get_collision_layer"):
		if body.get_collision_layer() == 1:
			position = body.position
	
	# for tilemaps (since tilemap bodies are shared)
	elif body.has_method("get_coords_for_body_rid"):
		var coords = body.get_coords_for_body_rid(body_rid)
		var tsize = body.tile_set.tile_size
		position = Vector2(body.position.x + coords.x * tsize.x, body.position.y + coords.y * tsize.y)
		
	return position
