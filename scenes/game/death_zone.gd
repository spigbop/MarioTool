extends Area2D


func _ready() -> void:
	body_entered.connect(on_enter)

func on_enter(body: Node2D) -> void:
	if body.has_method("enter_death_barrier"):
		body.enter_death_barrier()
