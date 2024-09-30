extends Node2D
class_name Music


@onready var loop: AudioStreamPlayer2D = $loop
@onready var start: AudioStreamPlayer2D = find_child("start")
@onready var end: AudioStreamPlayer2D = find_child("end")


func _ready() -> void:
	loop.finished.connect(on_loop_finished)
	if start:
		start.finished.connect(on_start_finished)
		start.play()

func end_music() -> void:
	if end:
		start.stop()
		loop.stop()
		end.play()

func on_start_finished() -> void:
	loop.play()

func on_loop_finished() -> void:
	loop.play()
