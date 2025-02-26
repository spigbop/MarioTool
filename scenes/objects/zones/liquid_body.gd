extends Area2D
class_name Liquid


@export var liquid_material: int = 0
@export var viscosity: float = .2:
	set(val):
		if val > 1.0:
			viscosity = 1.0
		elif val < .0:
			viscosity = .0
		else:
			viscosity = val


func _ready() -> void:
	body_entered.connect(body_enter)
	body_exited.connect(body_exit)


func body_enter(body: Node2D):
	if body.has_method("enter_liquid"):
		body.enter_liquid(viscosity, liquid_material)

func body_exit(body: Node2D):
	if body.has_method("exit_liquid"):
		body.exit_liquid(viscosity, liquid_material)
