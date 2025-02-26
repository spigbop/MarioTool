extends Camera2D
class_name LevelCamera


enum SCROLL_TYPE { PLAYER, AUTOSCROLL }
@export var scroll: SCROLL_TYPE = SCROLL_TYPE.PLAYER

var level_dimensions: Rect2 = Rect2(0.0, 0.0, 0.0, 0.0)
var player = null


func _ready() -> void:
	player = MarioTool.get_player()
	var dimensions: LevelDimensions = get_node_or_null("dimensions")
	if dimensions and dimensions.shape:
		var rect: Rect2 = dimensions.shape.get_rect()
		level_dimensions = Rect2(dimensions.position.x + rect.position.x + 128.0, dimensions.position.y + rect.position.y + 112.0, rect.size.x - 384.0, rect.size.y - 224.0)
	RenderingServer.set_default_clear_color(MarioTool.get_level_base().level_clear_color)


func set_camera_dims(blocks_width: int, blocks_height: int) -> void:
	level_dimensions = Rect2(0.0, 0.0, blocks_width * 16.0, blocks_height * 16.0)


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		player = MarioTool.get_player()
		if not is_instance_valid(player):
			self.set_script(load("res://scenes/editor/editor_camera.gd"))
			self.set_process(true)
			return
	position.x = clamp(player.position.x, level_dimensions.position.x, level_dimensions.size.x)
	position.y = clamp(player.position.y, level_dimensions.position.y, level_dimensions.size.y)
