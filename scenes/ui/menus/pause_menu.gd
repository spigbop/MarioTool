extends Node2D


@onready var menu: Node = $menu


func focus() -> void:
	menu.focused = true
	visible = true
	get_tree().paused = true

func unfocus() -> void:
	menu.focused = false
	menu.reset()
	visible = false
	get_tree().paused = false

func _ready() -> void:
	unfocus()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_cancel"):
		if menu.focused:
			unfocus()
		else:
			focus()


func m_continue() -> void:
	unfocus()

func m_exit_level() -> void:
	MarioTool.CURRENT_LEVEL.queue_free()

func m_quit_desktop() -> void:
	get_tree().quit()
