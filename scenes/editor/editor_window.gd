extends Window
class_name EditorWindow


@export var resistant = false


func _ready() -> void:
	close_requested.connect(on_close)
	instances.append(self)


func on_close() -> void:
	if not resistant:
		visible = false


static var instances: Array = []


static func on_maximized() -> void:
	for instance: EditorWindow in instances:
		instance.always_on_top = true
