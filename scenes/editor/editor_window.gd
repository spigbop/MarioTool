extends Window


func _ready() -> void:
	close_requested.connect(on_close)


func on_close() -> void:
	visible = false
