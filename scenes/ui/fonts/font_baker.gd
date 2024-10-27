@tool
extends Node
class_name FontBakery


@export var font_name: String
@export var atlas: Texture2D

@export_multiline var char_map: String

@export var offset: Vector2
@export var seperation: Vector2
@export var size: Vector2

@export var monospaced: bool = true

enum TEXT_METHOD { UNICODE, FILENAME }
@export var method: TEXT_METHOD = TEXT_METHOD.UNICODE
@export var bake_unnamed: bool = false
@export var set_true_to_bake: bool = false:
	set(newval):
		if newval:
			bake()


func bake() -> bool:
	if not Engine.is_editor_hint():
		return FAILED
	
	var result = OK
	var w: int = floori((float(atlas.get_width()) - offset.x + seperation.x) / (size.x + seperation.x))
	var h: int = floori((float(atlas.get_height()) - offset.y + seperation.y) / (size.y + seperation.y))
	
	var conf = ConfigFile.new()
	conf.set_value("settings", "monospaced", monospaced)
	
	if not DirAccess.dir_exists_absolute("res://scenes/ui/fonts/" + font_name):
		DirAccess.make_dir_absolute("res://scenes/ui/fonts/" + font_name)
	if not DirAccess.dir_exists_absolute("res://scenes/ui/fonts/" + font_name + "/characters"):
		DirAccess.make_dir_absolute("res://scenes/ui/fonts/" + font_name + "/characters")
	
	for wi in w:
		for hi in h:
			if hi == 0 and wi == 0:
				conf.set_value("settings", "width", size.x)
				conf.set_value("settings", "height", size.y)
			
			var file_name = str(hi) + "," + str(wi)
			var map_array = char_map.split("\n")
			if map_array.size() > hi and map_array[hi].length() > wi:
				file_name = map_array[hi][wi]
			elif not bake_unnamed:
				continue
			
			match method:
				TEXT_METHOD.UNICODE:
					file_name = file_name.unicode_at(0)
				TEXT_METHOD.FILENAME:
					if Text.REPLACEMENTS.has(file_name):
						file_name = Text.REPLACEMENTS.get(file_name)
					if not file_name.is_valid_filename():
						continue
			
			var texture = AtlasTexture.new()
			texture.atlas = self.atlas
			texture.region = Rect2(Vector2(offset.x + size.x * wi, offset.y + size.y * hi), Vector2(size.x, size.y))
			texture.filter_clip = true
			
			result = ResourceSaver.save(texture, "res://scenes/ui/fonts/" + font_name + "/characters/" + str(file_name) + ".tres")
	
	conf.save("res://scenes/ui/fonts/" + font_name + "/font.cfg")
	return result
