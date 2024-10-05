extends Area2D


func _ready() -> void:
	body_entered.connect(on_enter)
	body_exited.connect(on_exit)
	area_entered.connect(on_enter)
	area_exited.connect(on_exit)

func on_enter(body: Node2D) -> void:
	if body.has_method("enter_spawn_area"):
		body.enter_spawn_area()

func on_exit(body: Node2D) -> void:
	if body.has_method("exit_spawn_area"):
		body.exit_spawn_area()
