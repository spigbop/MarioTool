extends CharacterBody2D


# Basic Settings
const SPEED = 135.0 # 2.25 pixels/frame (Super Mario World)
const JUMP_VELOCITY = -350.0 # 4 blocks (Super Mario All Stars: Super Mario Bros)
const JUMP_VELOCITY_MIN = -150.0 # close guess (SMAS)

# Force Settings
const ACCELERATION = 8.0 # close guess (SMAS)
const DECELERATION = 14.0 # close guess (SMAS)

# Running Settings
const RUN_SPEED_MULTIPLIER = 1.5 # close guess (SMAS)
const RUN_ACCEL_MULTIPLIER = 1.1 # close guess (SMAS)
const RUN_JUMP_VELOCITY_MAX = 1.25 # 5 blocks (Super Mario All Stars: Super Mario Bros) 

var speed_mult = 1.0
var jump_mult = 1.0
var accel_mult = 1.0
var grounded = false
var ducking = false


@onready var sprite: AnimatedSprite2D = $sprite
@onready var jump_sound: AudioStreamPlayer2D = $channels/jump_sound
@onready var skid_sound: AudioStreamPlayer2D = $channels/skid_sound


@onready var jumping_factor = SPEED * RUN_SPEED_MULTIPLIER * 0.5 / RUN_JUMP_VELOCITY_MAX
var freeze = false


var logical_position = Vector2(0, 0)
var projectiles = []
var is_throwing = false


# physc process is fixed framerate
func _physics_process(delta: float) -> void:
	logical_position = position
	
	if freeze:
		return
	
	grounded = is_on_floor()
	
	var direction := Input.get_axis("left", "right")
	
	# Running & Shooting
	if Input.is_action_just_pressed("run_fire_decline"):
		speed_mult = RUN_SPEED_MULTIPLIER
		accel_mult = RUN_ACCEL_MULTIPLIER
		if powerup == 2 and projectiles.size() < 2:
			var fireball = load("res://scenes/effects/projectiles/fireball.tscn")
			var inst = fireball.instantiate()
			inst.player = get_node(".")
			if sprite.flip_h:
				inst.direction *= -1.0
			projectiles.append(inst)
			inst.position = position
			inst.position.x += 4.0 * inst.direction
			inst.position.y -= 12.0
			is_throwing = true
			add_sibling(inst)
		emit_signal("just_ran_or_fired")
	
	if Input.is_action_just_released("run_fire_decline"):
		speed_mult = 1.0
		accel_mult = 1.0
	
	# Animations & Gravity
	if not grounded:
		velocity += get_gravity() * delta
		sprite.animation = "jump"
	else:
		if velocity.x > 0:
			sprite.flip_h = false
			sprite.animation = "walking"
			sprite.speed_scale = velocity.x / SPEED * speed_mult
		elif velocity.x < 0:
			sprite.flip_h = true
			sprite.animation = "walking"
			sprite.speed_scale = -velocity.x / SPEED * speed_mult
		else:
			sprite.animation = "idle"
	
	# Skiding
	if velocity.x * direction < 0 and grounded:
		sprite.animation = "skid"
		if not skid_sound.playing:
			skid_sound.play()
			var skid_effect = load("res://scenes/effects/skid_effect.tscn")
			var skid = skid_effect.instantiate()
			skid.position = position
			skid.position.y += 6.0
			add_sibling(skid)
	
	# Ducking & Entering Downards Pipes
	if Input.is_action_pressed("down_duck") and grounded:
		if powerup > 0:
			sprite.animation = "duck"
			if not ducking:
				set_powerup_collisions(true)
				ducking = true
		emit_signal("just_ducked")
	if powerup > 0 and Input.is_action_just_released("down_duck"):
		set_powerup_collisions(false)
		ducking = false
	
	# Jumping
	jump_mult = clamp(abs(velocity.x * (speed_mult - 1.0) / jumping_factor), 1.0, 1.25)
	
	if Input.is_action_just_pressed("jump_accept") and grounded and not ducking:
		force_jump()
		jump_sound.play()
	
	if Input.is_action_just_released("jump_accept") and not grounded and velocity.y < 0:
		if velocity.y < JUMP_VELOCITY_MIN * jump_mult:
			velocity.y = JUMP_VELOCITY_MIN * jump_mult
		else:
			velocity.y = 0
	
	if grounded and is_throwing:
		sprite.animation = "throw"
	
	# Horizontal Movement
	if direction and not ducking:
		velocity.x = clamp(velocity.x + direction * accel_mult * ACCELERATION,
		-SPEED * speed_mult, SPEED * speed_mult)	
	else:
		if abs(velocity.x) > DECELERATION:
			if velocity.x > 0:
				velocity.x -= DECELERATION
			elif velocity.x < 0:
				velocity.x += DECELERATION
		else:
			velocity.x = 0
	
	move_and_slide()

func force_jump():
	velocity.y = JUMP_VELOCITY * jump_mult
	emit_signal("just_jumped")


@onready var collect_sound: AudioStreamPlayer2D = $channels/collect_sound


func coin_picker() -> void:
	collect_sound.play()


var powerup = 0
# 0: small, 1: big, 2: fire
const POWERUP_FRAMES = [
	preload("res://scenes/objects/resources/mario_small.tres"),
	preload("res://scenes/objects/resources/mario_big.tres"),
	preload("res://scenes/objects/resources/mario_fire.tres")]
const POWERUP_OFFSETS = [0.0, -8.0, -8.0, -8.0]
@onready var collision_big_mid: CollisionShape2D    = $collision_big_mid
@onready var collision_big_top: CollisionShape2D    = $collision_big_top
@onready var shape_big:         CollisionShape2D    = $hitbox/shape_big
@onready var powerup_sound:     AudioStreamPlayer2D = $channels/powerup_sound
@onready var powerup_timer:     Timer               = $hitbox/powerup_timer

func powerup_picker(tier) -> void:
	if lost:
		return
	if tier == 1 and powerup > 0 or powerup == tier:
		#powerup_same_sound.play()
		return
	else:
		powerup_sound.play()
		set_powerup(tier)


@onready var pipe_sound: AudioStreamPlayer2D = $channels/pipe_sound
@onready var iframes_timer: Timer = $hitbox/iframes_timer
@onready var iframes_animation: AnimationPlayer = $hitbox/iframes_animation
var iframes = false


func hurt() -> void:
	if iframes:
		return
	if powerup > 0:
		pipe_sound.play()
		set_powerup(clamp(powerup - 1, 0, 1))
	else:
		lose_life()

func _on_iframes_timer_timeout() -> void:
	iframes = false
	iframes_animation.stop()
	sprite.visible = true

func set_powerup(tier) -> void:
	powerup = tier
	freeze = true
	iframes = true
	if tier == 0:
		sprite.speed_scale = -1.0
		sprite.animation = "transform"
		set_powerup_collisions(true)
	else:
		sprite.sprite_frames = POWERUP_FRAMES[tier]
		sprite.speed_scale = 1.0
		sprite.offset.y = POWERUP_OFFSETS[tier]
		set_powerup_collisions(false)
	sprite.animation = "transform"
	powerup_timer.start()
	iframes_timer.start()
	sprite.play()
	

func set_powerup_collisions(enabled) -> void:
	collision_big_mid.set_deferred("disabled", enabled)
	collision_big_top.set_deferred("disabled", enabled)
	shape_big.set_deferred("disabled", enabled)

func _on_powerup_timer_timeout() -> void:
	iframes_animation.play("default")
	sprite.animation = "idle"
	sprite.play()
	freeze = false
	if powerup == 0:
		sprite.sprite_frames = POWERUP_FRAMES[0]
		sprite.offset.y = POWERUP_OFFSETS[0]
		sprite.play()

func block_bumper() -> void:
	return


func stomper():
	return


var lost = false
@onready var lose_life_sound: AudioStreamPlayer2D = $channels/lose_life_sound


func lose_life():
	if lost:
		return
	lost = true
	var fallen_foe_effect = load("res://scenes/effects/fallen_effect.tscn")
	var effect = fallen_foe_effect.instantiate()
	effect.position = position
	effect.velocity.y *= 1.5
	var effect_sprite = effect.get_node("sprite")
	effect_sprite.texture = load("res://scenes/objects/resources/mario_dead.tres")
	add_sibling(effect)
	sprite.set_deferred("visible", false)
	lose_life_sound.play()
	freeze = true
	var music = get_parent().get_node("main_camera/level_music")
	if music:
		music.queue_free()
	var death_timer = get_parent().get_node("testroom_death_timer")
	if death_timer:
		death_timer.start()


# Methods
func is_running() -> bool:
	return speed_mult > 1.0
