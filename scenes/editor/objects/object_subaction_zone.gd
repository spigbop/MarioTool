extends Area2D


var active = false
var occupied = false


func _ready() -> void:
	body_entered.connect(on_enter)


func on_enter(node: Node2D) -> void:
	if active:
		node.queue_free()
		
		active = false
