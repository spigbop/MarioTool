extends Node
class_name GameTextConnector


@export var var_or_func = "is_fullscreen"
@export var format = "%s"
var value = null

@onready var subject = find_child("text")
@onready var is_func = typeof(MarioTool.inst.get(var_or_func)) == 25


func _ready() -> void:
	upd()

func upd() -> void:
	if is_func:
		value = MarioTool.inst.call(var_or_func)
	else:
		value = MarioTool.inst.get(var_or_func)
	formulate()

func formulate() -> void:
	if not subject:
		return
	
	var val = null
	if format.contains(":"):
		val = Mathx.bool_gate(value, format.split(':')[0], format.split(':')[1])
	else:
		val = format % str(value)
	
	if "text" in subject:
		subject.text = val
	if "value" in subject:
		subject.value = value
	if subject.has_method("upd"):
		subject.upd()
