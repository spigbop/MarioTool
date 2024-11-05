extends Timer


func _ready() -> void:
	timeout.connect(on_timeout)

func on_timeout() -> void:
	if Player.remaining_lives == -1:
		Player.remaining_lives = Player.MAX_LIVES
		Coin.coin_count = 0
		var packed: PackedScene = load("res://scenes/ui/menus/game_over.tscn")
		var instance = packed.instantiate()
		instance.position = Vector2.ZERO
		add_sibling(instance)
	else:
		MarioTool.reset_level()
