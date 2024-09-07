extends Area2D


@export var destination: Vector2               = Vector2.ZERO
@export var enter_towards: MarioTool.DIRECTION = MarioTool.DIRECTION.SOUTH
@export var exit_towards: MarioTool.DIRECTION  = MarioTool.DIRECTION.NORTH


func _ready() -> void:
	body_entered.connect(body_entered)
	body_exited.connect(body_exited)
	
func body_entered() -> void:
	
