@tool
extends Node2D
class_name LevelDimensions


@export var shape: RectangleShape2D = null

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
	else:
		queue_free()

func _draw() -> void:
	draw_rect(shape.get_rect(), Color.CORAL, false, 2.0, false)
