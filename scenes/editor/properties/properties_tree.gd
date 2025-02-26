extends Tree


@onready var boss: Window = get_parent()
@onready var world_layer: CanvasLayer = $"../world_container/world/layer"
@onready var demo_object: Node2D = $"../world_container/world/layer/demo_object"
var subject = null


func _ready() -> void:
	item_edited.connect(on_item_edited)

@onready var position_label: Label = $"../position"

func load_instance(inst: Node) -> void:
	if not boss.visible:
		return
	
	subject = inst
	boss.title = str(inst).split('<')[0].left(-1)
	position_label.text = "x: " + str(inst.position.x) + " y: " + str(inst.position.y)
	
	var packed: PackedScene = PackedScene.new()
	packed.pack(inst)
	var demo_pos = demo_object.position
	demo_object.queue_free()
	demo_object = packed.instantiate()
	demo_object.position = demo_pos
	demo_object.visible = true
	world_layer.add_child(demo_object)
	
	filter(current_filter)


var current_filter: String = ""
var item_array: Array = []
func filter(search: String = "") -> void:
	current_filter = search
	item_array.clear()
	
	clear()
	var root: TreeItem = create_item(null)
	root.set_text(0, "root")
	
	for property in subject.get_script().get_script_property_list():
		if not search == "" and not property.name.contains(search) or property.name.ends_with(".gd"):
			continue
		var item = create_item(root)
		item.set_text(0, property.name)
		var value = subject.get(property.name)
		if is_instance_valid(value) and value.has_method("get_script"):
			filter_depth(value, item)
		item.set_text(1, str(value))
		item.set_editable(1, true)
		item_array.append(item)


func filter_depth(node, parent: TreeItem) -> void:
	var script = node.get_script()
	if script:
		for property in node.get_script().get_script_property_list():
			if not current_filter == "" and not property.name.contains(current_filter) or property.name.ends_with(".gd"):
				continue
			var item = create_item(parent)
			item.set_text(0, property.name)
			var value = node.get(property.name)
			if is_instance_valid(value) and value.has_method("get_script") and not value == subject:
				filter_depth(value, item)
			item.set_text(1, str(value))
			item.set_editable(1, true)
			item_array.append(item)


func update_properties() -> void:
	for item in item_array:
		item.set_text(1, str(subject.get(item.get_text(0))))


func on_item_edited() -> void:
	var item: TreeItem = get_selected()
	var executee = subject
	
	var parent = item.get_parent()
	if not parent.get_text(0) == "root":
		print(parent.get_text(1))
		#executee = convert(parent.get_text(1), 24)
	
	Deferation.execute_on(executee, [item.get_text(0) + "=" + item.get_text(1)])
