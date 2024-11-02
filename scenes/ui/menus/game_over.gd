extends Node2D


@onready var menu_appear_timer: Timer = $menu_appear_timer
@onready var menu: TextMenu = $menu


func _ready() -> void:
	get_tree().paused = true
	menu_appear_timer.timeout.connect(menu_appear)


func menu_appear() -> void:
	menu.visible = true
	menu.focused = true


func on_menu_accepted(index: int, _menu: String) -> void:
	get_tree().paused = false
	match index:
		0:
			MarioTool.exit_level()
			queue_free()
		1:
			pass
		2:
			MarioTool.quit_to_desktop()
