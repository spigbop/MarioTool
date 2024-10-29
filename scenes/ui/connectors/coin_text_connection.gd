extends Node
class_name CoinTextConnector


func _ready() -> void:
	find_child("text").text = str(Coin.coin_count)
