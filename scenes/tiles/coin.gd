extends Area2D
class_name Coin


static var coin_count: int = 0


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("coin_picker"):
		collect(body)
	if body.has_method("coin_popper"):
		on_appear(0)

func collect(body: Node2D = null) -> void:
	if body and body.has_method("coin_picker"):
		body.coin_picker()
	coin_count += 1
	queue_free()


func on_appear(_ptier) -> void:
	var coin_spin_effect = load("res://scenes/effects/tiles/coin_spin_effect.tscn")
	var effect = coin_spin_effect.instantiate()
	effect.position = position
	add_sibling(effect)
	collect()
