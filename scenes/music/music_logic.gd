extends Node2D


@onready var loop: AudioStreamPlayer2D = $loop
@onready var start: AudioStreamPlayer2D = $start


func _ready() -> void:
	start.play()

func _on_start_finished() -> void:
	loop.play()

func _on_loop_finished() -> void:
	loop.play()
