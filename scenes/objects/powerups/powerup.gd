extends RigidBody2D


@export var tier = 1
@export var needs_super = false
@onready var ai: Node = find_child("ai")


func enter_spawn_area() -> void:
	if ai:
		ai.spawn()


func on_appear(powerup_tier = null) -> void:
	if needs_super and powerup_tier == 0:
		DummySpawner.spawn_from_pipe(self, "res://scenes/objects/powerups/super_mushroom.tscn", self.position)
	else:
		DummySpawner.spawn_from_pipe(self, self.scene_file_path, self.position)
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("powerup_picker"):
		body.powerup_picker(tier)
		queue_free()
