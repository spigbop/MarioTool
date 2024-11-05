extends Camera2D


enum SCROLL_TYPE { LINEAR, AUTOSCROLL }
@export var scroll: SCROLL_TYPE = SCROLL_TYPE.LINEAR
@export var level_dimensions: Rect2 = Rect2(0.0, 0.0, 0.0, 0.0)

var player = null


func _ready() -> void:
	player = MarioTool.get_player()

func set_camera_dims(blocks_width: int, blocks_height: int) -> void:
	level_dimensions = Rect2(0.0, 0.0, blocks_width * 16.0, blocks_height * 16.0)


func _physics_process(_delta: float) -> void:
	position.x = clamp(player.position.x, level_dimensions.position.x, level_dimensions.size.x)
	position.y = clamp(player.position.y, level_dimensions.position.y, level_dimensions.size.y)
