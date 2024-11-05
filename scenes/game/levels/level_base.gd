extends Node2D
class_name Level


@onready var maps: Node2D = get_parent().get_node("maps")
@onready var contents: Node2D = get_parent().get_node("contents")

var level_dimensions: Rect2 = Rect2(0, 0, 0, 0)
var player_spawn: Vector2 = Vector2.ZERO


func spawn(grp: String, obj: String) -> String:
	var file_path: String = "res://scenes/objects/" + grp + "/" + obj + ".tscn"
	if FileAccess.file_exists(file_path):
		var pack: PackedScene = load(file_path)
		var subject: Node = pack.instantiate()
		if "position" in subject:
			subject.position = MarioTool.get_player().position
			subject.position.x += 48.0
		contents.add_child(subject)
		return "Spawned: " + obj + " (" + grp.substr(0, 1) + ")"
	
	return "Failed to find: " + obj


func spawn_enemy(enemy: String) -> String:
	return spawn("enemies", enemy)

func spawn_powerup(powerup: String) -> String:
	return spawn("powerups", powerup)
