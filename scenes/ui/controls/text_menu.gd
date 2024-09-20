extends Node
class_name TextMenu


@export var focused: bool = true:
	set(newval):
		focused = newval
		set_process(focused)
@export var selected_index: int = 0
@export var function_calls: PackedStringArray = []
@onready var cursor: Node2D = $cursor
var buttons = []

@onready var boss = get_parent()


func _ready() -> void:
	initial_cur_pos = cursor.position
	recognise_buttons()
	set_process(focused)

func recognise_buttons() -> void:
	buttons.clear()
	for child in find_child("buttons").get_children():
		buttons.append(child)

var initial_cur_pos = Vector2.ZERO
var initial_index = selected_index

func reset() -> void:
	selected_index = initial_index
	cursor.position = initial_cur_pos


var cooldown: float = 0.0
func _process(delta: float) -> void:
	if focused and Input.is_action_just_pressed("jump_accept"):
		var fun = function_calls[selected_index]
		if boss.has_method(fun):
			boss.call(fun)
	
	cooldown -= delta
	if cooldown > 0.0:
		return
	
	if Input.is_action_pressed("down_duck"):
		cooldown = 0.09
		selected_index = Mathx.clampi_cycle(selected_index + 1, 0, buttons.size() - 1)
		cursor.position.y = buttons[selected_index].position.y
	
	if Input.is_action_pressed("up_interact"):
		cooldown = 0.09
		selected_index = Mathx.clampi_cycle(selected_index - 1, 0, buttons.size() - 1)
		cursor.position.y = buttons[selected_index].position.y
