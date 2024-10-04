extends Sprite2D


const HANDLE_SELECTED = preload("res://scenes/ui/controls/resources/handle_selected.tres")
const HANDLE_UNSELECTED = preload("res://scenes/ui/controls/resources/handle_unselected.tres")
var selected = false

@onready var handle: Sprite2D = $handle
@export var value: float = 0.5
@onready var position_multiplier: float = 26.0


func _ready() -> void:
	upd()

func toggle() -> void:
	if selected:
		unselect()
	else:
		select()

func select() -> void:
	handle.texture = HANDLE_SELECTED
	selected = true

func unselect() -> void:
	handle.texture = HANDLE_UNSELECTED
	selected = false

func upd() -> void:
	handle.position.x = clamp(value * 26.0 - 13.0, -13.0, 13.0)
