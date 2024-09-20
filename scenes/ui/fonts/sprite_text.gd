@tool
extends Node2D


class_name Text


@export var font: String = "smas_outline":
	set(newval):
		font = newval
		print_text()
@export var text: String = "":
	set(newval):
		text = newval
		print_text()


const REPLACEMENTS = {
	".": "dot"
}
var offset_x: float = 0.0


func _ready() -> void:
	if not Engine.is_editor_hint():
		print_text()

func print_text() -> void:
	offset_x = 0.0
	for child in get_children():
		child.queue_free()
	for ind in text.length():
		var chartext = text[ind].to_lower()
		if chartext == " ":
			offset_x -= 5.0
			continue
		if chartext in REPLACEMENTS:
			chartext = REPLACEMENTS[chartext]
		var resource_path = "res://scenes/ui/fonts/" + font + "/characters/" + chartext + ".tres"
		if ResourceLoader.exists(resource_path):
			var chr = Sprite2D.new()
			chr.position = Vector2(10.0 * ind + offset_x, 0.0)
			chr.texture = load(resource_path)
			add_child(chr)
