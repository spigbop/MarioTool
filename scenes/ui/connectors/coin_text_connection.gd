extends Node
class_name CoinTextConnector


@onready var subject = find_child("text")


func _ready() -> void:
	upd()


func upd() -> void:
	subject.text = str(Coin.coin_count).pad_zeros(2)
