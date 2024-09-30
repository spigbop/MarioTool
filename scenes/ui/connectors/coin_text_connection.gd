extends Node


func _ready() -> void:
	find_child("text").text = str(Coin.coin_count)
