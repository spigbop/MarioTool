extends RigidBody2D


enum POWERUP_TYPE { PLAYER_STATE, LIVES, HURT, NONE }
@export var type: POWERUP_TYPE = POWERUP_TYPE.PLAYER_STATE
@export var tier = 1
@export var needs_super = false
@export var object_deferation: PackedStringArray


@onready var ai: Node = find_child("ai")
@onready var hitbox: Area2D = $hitbox


static var mushrooms_in_scene: Array = []
static func _static_init() -> void:
	mushrooms_in_scene = []

func _ready() -> void:
	hitbox.body_entered.connect(hitbox_entered)


func enter_spawn_area() -> void:
	if tier == 1:
		mushrooms_in_scene.append(self)
	if ai:
		ai.spawn()

func exit_spawn_area() -> void:
	if tier == 1 and mushrooms_in_scene.has(self):
		mushrooms_in_scene.erase(self)

func enter_death_barrier() -> void:
	despawn()


func on_appear(powerup_tier = null) -> void:
	if needs_super and powerup_tier == 0 and mushrooms_in_scene.size() == 0:
		DummySpawner.spawn_from_pipe(self, "res://scenes/objects/powerups/super_mushroom.tscn", self.position)
	else:
		DummySpawner.spawn_from_pipe(self, self.scene_file_path, self.position)
	despawn()


func hitbox_entered(body: Node2D) -> void:
	if body.has_method("powerup_picker"):
		if type == POWERUP_TYPE.PLAYER_STATE:
			body.powerup_picker(tier)
		elif type == POWERUP_TYPE.LIVES and "remaining_lives" in body:
			body.remaining_lives += tier
			if body.has_method("life_picker"):
				body.life_picker()
				var level_ov = MarioTool.get_level_overlay()
				if level_ov:
					level_ov.get_node("lives_count").upd()
		elif type == POWERUP_TYPE.HURT and body.has_method("hurt"):
			body.hurt()
		Deferation.execute_on(body, object_deferation)
		despawn()


func despawn() -> void:
	if tier == 1 and mushrooms_in_scene.has(self):
		mushrooms_in_scene.erase(self)
	queue_free()
