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
enum TEXT_ALIGNMENT { LEFT, CENTER, RIGHT }
@export var alignment: TEXT_ALIGNMENT = TEXT_ALIGNMENT.LEFT:
	set(newval):
		alignment = newval
		print_text()
@export var spacing: float = 2.0:
	set(newval):
		spacing = newval
		char_increment = 8.0 + newval
		print_text()
var char_increment = 10.0


const REPLACEMENTS = {
	".": "dot"
}
var offset_x: float = 0.0
var sprites = []


func _ready() -> void:
	pass
	#if not Engine.is_editor_hint():
	#	print_text()


func print_text() -> void:
	offset_x = 0.0
	sprites = []
	for child in get_children():
		child.queue_free()
	for ind in text.length():
		var chartext = text[ind].to_lower()
		if chartext == " ":
			offset_x -= char_increment / 2
			continue
		if chartext in REPLACEMENTS:
			chartext = REPLACEMENTS[chartext]
		var resource_path = "res://scenes/ui/fonts/" + font + "/characters/" + chartext + ".tres"
		if ResourceLoader.exists(resource_path):
			var chr = Sprite2D.new()
			chr.position = Vector2(char_increment * ind + offset_x, 0.0)
			chr.texture = load(resource_path)
			sprites.append(chr)
			add_child(chr)
	if alignment == TEXT_ALIGNMENT.CENTER:
		var offset_alignment = (char_increment * text.length() + offset_x) / 2
		for chr in sprites:
			chr.position.x -= offset_alignment
			chr.position.x += char_increment / 2
	elif alignment == TEXT_ALIGNMENT.RIGHT:
		var offset_alignment = char_increment * text.length() + offset_x
		for chr in sprites:
			chr.position.x -= offset_alignment
			chr.position.x += char_increment
