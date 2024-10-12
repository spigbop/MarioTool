extends AI
class_name Ledge


@export var ledgebox_name: String = "ledge"

@onready var patrol: Patrolling = get_parent()
@onready var rigid: RigidBody2D = patrol.get_parent()


func _ready() -> void:
	var ledgebox = rigid.find_child(ledgebox_name)
	if ledgebox:
		ledgebox.body_exited.connect(body_exited)


func body_exited(_body: Node2D) -> void:
	if rigid.has_method("on_ledge"):
		rigid.call_deferred("on_ledge")
	patrol.force_turn()
