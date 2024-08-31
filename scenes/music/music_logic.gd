extends Node2D


func _on_start_finished() -> void:
	$loop.play()

func _on_loop_finished() -> void:
	$loop.play()
