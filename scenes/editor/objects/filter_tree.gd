extends LineEdit


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		EditorCamera.frozen = false


func _ready() -> void:
	text_changed.connect(on_text_change)
	focus_entered.connect(on_focus_enter)
	focus_exited.connect(on_focus_exit)


func on_focus_enter() -> void:
	EditorCamera.frozen = true

func on_focus_exit() -> void:
	EditorCamera.frozen = false


@onready var objects_tree: Tree = $"../tree"


func on_text_change(new: String) -> void:
	objects_tree.filter(new)
