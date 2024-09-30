extends Timer


func _ready() -> void:
	timeout.connect(on_timeout)

func on_timeout() -> void:
	MarioTool.reset_level()
