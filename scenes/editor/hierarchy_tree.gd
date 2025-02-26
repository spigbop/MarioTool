extends Tree
class_name EditorHierarchy


enum ICON { GENERIC, ENEMY, POWERUP, ZONE, GROUP }
static var icons: Array = [
	preload("res://assets/textures/editor/icons/file.png"),
	preload("res://assets/textures/editor/icons/file.png"),
	preload("res://assets/textures/editor/icons/file.png"),
	preload("res://assets/textures/editor/icons/file.png"),
	preload("res://assets/textures/editor/icons/folder.png")
]
var root: TreeItem


var tree_dict: Dictionary = {}


func _ready() -> void:
	root = create_item(null)


func add(object: Node2D, icon: ICON = ICON.GENERIC) -> void:
	var item: TreeItem = create_item(root)
	item.set_text(0, object.name)
	item.set_icon(0, icons[icon])
	tree_dict[object.name] = item


func remove(object: Node2D) -> void:
	remove_named(object.name)


func remove_named(object: String) -> void:
	if tree_dict.has(object):
		tree_dict[object].queue_free()
		tree_dict.erase(object)


func filter(query: String) -> void:
	if query == "":
		for item in tree_dict:
			tree_dict[item].visible = true
		return
	
	for item in tree_dict:
		tree_dict[item].visible = item.contains(query)
