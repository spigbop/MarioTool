extends Area2D


@export var destination: Vector2               = Vector2.ZERO
@export var enter_towards: MarioTool.DIRECTION = MarioTool.DIRECTION.SOUTH
@export var exit_towards: MarioTool.DIRECTION  = MarioTool.DIRECTION.NORTH
@export var can_only_enter_once: bool = false

var subject = null
var keys = [ "up_enter", "down_duck", "left", "right" ]


func _ready() -> void:
	set_process(false)
	body_entered.connect(on_enter)
	body_exited.connect(on_exit)


func _process(_delta: float) -> void:
	if Input.is_action_pressed(keys[enter_towards]) and subject and not subject.freeze:
		warp_subject()


var warping_subject = null
var current_texture = null
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
		current_texture = warping_subject.sprite.sprite_frames.get_frame_texture(warping_subject.sprite.animation, warping_subject.sprite.frame)
		var effect = DummySpawner.spawn_from_pipe(self, current_texture, Vector2(position.x, position.y + 16.0), true, enter_towards, 0.0, 0.7, warp_reach_destination)
		effect.get_node("sprite").flip_h = warping_subject.sprite.flip_h

func warp_reach_destination(_node) -> void:
	warping_subject.position = destination
	warping_subject.pipe_sound.play()
	var effect = DummySpawner.spawn_from_pipe(self, current_texture, destination, true, exit_towards, 0.0, 0.7, warp_finalise)
	effect.get_node("sprite").flip_h = warping_subject.sprite.flip_h

func warp_finalise(_node) -> void:
	warping_subject.freeze = false
	if warping_subject.powerup > 0:
		warping_subject.set_powerup_collisions(false)
		warping_subject.ducking = false
	warping_subject.visible = true
	subject = null
	if not can_only_enter_once:
		once = false


func on_enter(body: Node2D) -> void:
	if body.has_method("pipe_warper"):
		subject = body
		set_process(true)
		body.pipe_warper()


func on_exit(body: Node2D) -> void:
	if subject == body:
		subject = null
