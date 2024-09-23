extends Area2D


@export var destination: Vector2               = Vector2.ZERO
@export var enter_towards: MarioTool.DIRECTION = MarioTool.DIRECTION.SOUTH
@export var exit_towards: MarioTool.DIRECTION  = MarioTool.DIRECTION.NORTH
@export var can_only_enter_once: bool = false

var subject = null
var keys = [ "up_enter", "down_duck", "left", "right" ]


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	if Input.is_action_pressed(keys[enter_towards]):
		warp_subject()


var warping_subject = null
var once = false
func warp_subject() -> void:
	if not once and subject:
		once = true
		warping_subject = subject
		warping_subject.visible = false
		warping_subject.freeze = true
		warping_subject.pipe_sound.play()
		warping_subject.iframes = true
		warping_subject.iframes_timer.start()
		var effect = DummySpawner.spawn_from_pipe(self, warping_subject.sprite.sprite_frames.get_frame_texture(warping_subject.sprite.animation, warping_subject.sprite.frame), Vector2(position.x, position.y + 16.0), true, enter_towards, 0.0, 0.7, warp_reach_destination)
		effect.get_node("sprite").flip_h = warping_subject.sprite.flip_h

func warp_reach_destination() -> void:
	warping_subject.position = destination
	warping_subject.pipe_sound.play()
	var effect = DummySpawner.spawn_from_pipe(self, warping_subject.sprite.sprite_frames.get_frame_texture(warping_subject.sprite.animation, warping_subject.sprite.frame), destination, true, exit_towards, 0.0, 0.7, warp_finalise)
	effect.get_node("sprite").flip_h = warping_subject.sprite.flip_h

func warp_finalise() -> void:
	warping_subject.freeze = false
	if warping_subject.powerup > 0:
		warping_subject.set_powerup_collisions(false)
		warping_subject.ducking = false
	warping_subject.visible = true
	subject = null
	if not can_only_enter_once:
		once = false


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("can_warp"):
		subject = body
		set_process(true)
		body.can_warp()


func _on_body_exited(body: Node2D) -> void:
	if subject == body:
		subject = null
