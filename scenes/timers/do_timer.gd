extends Timer
class_name DoTimer


@onready var boss: Node = get_parent()
@export var object_deferation: PackedStringArray


func _ready() -> void:
	timeout.connect(on_timeout)


func on_timeout() -> void:
	Deferation.execute_on(boss, object_deferation)
