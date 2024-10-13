extends Node


@export var subject_paths: PackedStringArray
var loads = []
@onready var generator: Area2D = find_child("generator")
@onready var tile_layer = find_child("layer")


func _ready() -> void:
	if not generator or subject_paths.size() == 0:
		queue_free()
		return
	for path in subject_paths:
		loads.append(load(path))

func on_event_block_hit(times) -> void:
	generator.subject = loads[times % subject_paths.size()]
	if tile_layer:
		tile_layer.visible = not tile_layer.visible
