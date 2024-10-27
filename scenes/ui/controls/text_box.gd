extends LineEdit
class_name TextBox


@export var focused: bool = false:
	set(newval):
		focused = newval
		if focused:
			grab_focus()
			select(text.length())
		else:
			release_focus()
		set_process(focused)
@export var boss: Node
@export var subject: Text

@export var blacklisted: PackedStringArray


func _ready() -> void:
	if not subject:
		queue_free()
	visible = false
	text_changed.connect(on_text_change)
	text_submitted.connect(on_submit)
	focus_exited.connect(on_focus_exited)
	set_process(focused)


func on_text_change(newtext: String) -> void:
	for c in newtext:
		if c in blacklisted or not subject.alphabet.has(c.unicode_at(0)):
			newtext = newtext.replace(c, "")
			var caret_col_load = caret_column
			text = newtext
			caret_column = caret_col_load
	subject.text = newtext

func on_submit(submitted) -> void:
	if boss:
		text = ""
		subject.text = ""
		boss.call("on_submit", submitted)

func on_focus_exited() -> void:
	if focused:
		grab_focus()


var blinking: float = caret_blink_interval
@export var cursor: Text
@onready var init_cur_pos_x: float = cursor.position.x

func _process(delta: float) -> void:
	blinking -= delta
	var cur_pos_x = init_cur_pos_x + caret_column * 6.0
	if cur_pos_x != cursor.position.x:
		cursor.position.x = cur_pos_x
		cursor.visible = true
		blinking = caret_blink_interval
	elif blinking < 0:
		blinking = caret_blink_interval
		cursor.visible = not cursor.visible
