extends Tree


func _ready() -> void:
	item_selected.connect(on_item_selected)
	filter()

var folder_icon = preload("res://assets/textures/editor/icons/folder.png")
var file_icon = preload("res://assets/textures/editor/icons/file.png")

func filter(search: String = "") -> void:
	clear()
	var root: TreeItem = create_item(null)
	root.set_text(0, "root")
	
	if search == "" or "player_spawn".contains(search):
		var player = create_item(root)
		player.set_icon(0, file_icon)
		player.set_text(0, "player_spawn")
	
	for dir in DirAccess.get_directories_at("res://scenes/objects"):
		var category: TreeItem = create_item(root)
		category.set_icon(0, folder_icon)
		var category_path: PackedStringArray = dir.split('/')
		var category_name: String = category_path[category_path.size() - 1]
		category.set_text(0, category_name)
		
		var object_count: int = 0
		for file in DirAccess.get_files_at("res://scenes/objects/" + category_name):
			if file.ends_with(".tscn"):
				var path: PackedStringArray = file.split('/')
				var element_name = path[path.size() - 1].left(-5)
				if not search == "" and not element_name.contains(search):
					continue
				var element: TreeItem = create_item(category)
				element.set_icon(0, file_icon)
				element.set_text(0, element_name)
				object_count += 1
		
		if object_count == 0:
			category.free()


@onready var demo_object: Node2D = $"../world_container/world/layer/demo_object"
@onready var world_layer: Node = $"../world_container/world/layer"


func on_item_selected() -> void:
	var item = get_selected()
	var parent = item.get_parent()
	
	var folder = parent.get_text(0) + "/"
	if folder == "root/":
		folder = ""
	
	EditorCamera.type = EditorCamera.TOOL_TYPE.OBJECTS
	var item_name = item.get_text(0)
	var scene_path = "res://scenes/objects/" + folder + item_name + ".tscn"
	if item_name == "player_spawn":
		scene_path = "res://scenes/editor/gizmos/player_spawn.tscn"
	MarioTool.editor.objects_selected_path = scene_path
	
	var packed: PackedScene = load(scene_path)
	var demo_pos = demo_object.position
	demo_object.queue_free()
	demo_object = packed.instantiate()
	demo_object.position = demo_pos
	demo_object.visible = true
	world_layer.add_child(demo_object)
