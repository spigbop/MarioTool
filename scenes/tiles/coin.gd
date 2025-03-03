extends Area2D
class_name Coin


static var coin_count: int = 0:
	set(newval):
		coin_count = newval
		if coin_count == 100:
			coin_count = 0
			Player.remaining_lives += 1
			MarioTool.get_player().life_picker()
		var level_ov = MarioTool.get_level_overlay()
		if level_ov:
			level_ov.get_node("coin_count").upd()
			if coin_count == 0:
				level_ov.get_node("lives_count").upd()


func _ready() -> void:
	body_entered.connect(on_enter)

func on_enter(body: Node2D) -> void:
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
