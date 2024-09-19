extends RigidBody2D


@export var tier = 1
@export var needs_super = false
@onready var ai: Node = find_child("ai")


static var mushrooms_in_scene = []


func enter_spawn_area() -> void:
	if tier == 1:
		mushrooms_in_scene.append(self)
	if ai:
		ai.spawn()

func enter_death_barrier() -> void:
	despawn()


func on_appear(powerup_tier = null) -> void:
	if needs_super and powerup_tier == 0 and mushrooms_in_scene.size() == 0:
		DummySpawner.spawn_from_pipe(self, "res://scenes/objects/powerups/super_mushroom.tscn", self.position)
	else:
		DummySpawner.spawn_from_pipe(self, self.scene_file_path, self.position)
	despawn()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("powerup_picker"):
		body.powerup_picker(tier)
		despawn()


func despawn():
	if tier == 1:
		mushrooms_in_scene.erase(self)
	queue_free()
