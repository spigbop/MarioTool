@tool
extends Node2D
class_name Text


@export var font: String = "smas_outline":
	set(newval):
		font = newval
		var conf_path = "res://scenes/ui/fonts/" + font + "font.cfg"
		if FileAccess.file_exists(conf_path):
			font_config.clear()
			font_config.load(conf_path)
		width = font_config.get_value("settings", "width", 8.0)
		height = font_config.get_value("settings", "height", 8.0)
		monospaced = font_config.get_value("settings", "monospaced", true)
		if auto_print:
			print_text()
@export var text: String = "":
	set(newval):
		text = newval
		if auto_print:
			print_text()
enum TEXT_ALIGNMENT { LEFT, CENTER, RIGHT }
@export var alignment: TEXT_ALIGNMENT = TEXT_ALIGNMENT.LEFT:
	set(newval):
		alignment = newval
		if auto_print:
			print_text()
@export var spacing: Vector2 = Vector2(2.0, 0.0):
	set(newval):
		spacing = newval
		if auto_print:
			print_text()

@export var multiline: bool = false
@export var reverse_newline: bool = false
@export var method: FontBakery.TEXT_METHOD = FontBakery.TEXT_METHOD.UNICODE

var font_config: ConfigFile = ConfigFile.new()
var width: float = 8.0
var height: float = 8.0
var monospaced: bool = true


const REPLACEMENTS = {
	".": "dot"
}
var offset_x: float = 0.0
var sprites = []


var auto_print: bool = true

# printing currently erases and then creates sprite children.
# this is costly when animating. I will find a better way for animations.


func print_text() -> void:
	sprites = []
	var char_increment: float = 10.0
	if monospaced:
		char_increment = width + spacing.x
	for child in get_children():
		child.queue_free()
	var lines = []
	if multiline:
		lines = text.split("\\n")
	else:
		lines.append(text)
	for lni in lines.size():
		offset_x = 0.0
		for ind in lines[lni].length():
			var chartext = lines[lni][ind]
			if chartext == " " and not monospaced:
				offset_x -= char_increment / 2
				continue
			
			match method:
				FontBakery.TEXT_METHOD.UNICODE:
					chartext = str(chartext.unicode_at(0))
				FontBakery.TEXT_METHOD.FILENAME:
					if chartext in REPLACEMENTS:
						chartext = REPLACEMENTS[chartext]
			
			var resource_path = "res://scenes/ui/fonts/" + font + "/characters/" + chartext + ".tres"
			if ResourceLoader.exists(resource_path):
				var chr = Sprite2D.new()
				chr.position = Vector2(char_increment * ind + offset_x, (height + spacing.y) * lni * 1.5 * Mathx.bool_gate(reverse_newline, -1.0, 1.0))
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

var alphabet = null:
	get:
		if alphabet:
			return alphabet
		var job = DirAccess.open("res://scenes/ui/fonts/" + font + "/characters/")
		job.list_dir_begin()
		alphabet = []
		for file: String in job.get_files():
			alphabet.append(int(file.left(-5)))
		#space
		alphabet.append(32)
		return alphabet
