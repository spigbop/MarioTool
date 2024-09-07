extends Node


@onready var rigid: RigidBody2D = get_parent()
@export var hitbox_name = "hitbox"
@export var force_jump = true
@export var autostart = false

@onready var shape_offset = 6.0


func _ready() -> void:
	if autostart:
		spawn()

var spawned = false

func spawn() -> void:
	if not spawned:
		spawned = true
		var hitbox = rigid.get_node(hitbox_name)
		shape_offset = hitbox.get_node("shape").shape.size.y / 2.0 - 1.0
		hitbox.body_entered.connect(body_entered)

func body_entered(body: Node2D) -> void:
	if body.has_method("stomper"):
		if body.logical_position.y < rigid.position.y - shape_offset:
				if force_jump and body.has_method("force_jump"):
					body.force_jump()
				
				if rigid.has_method("on_stomp"):
					rigid.on_stomp()
					
				if rigid.has_method("on_kick"):
					rigid.on_kick(body.logical_position, true)
		else:
			if rigid.has_method("on_contact"):
				rigid.on_contact(body)
			
			if rigid.has_method("on_kick"):
				rigid.on_kick(body.logical_position, false)
