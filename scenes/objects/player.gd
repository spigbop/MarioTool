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


# physc process is fixed framerate
func _physics_process(delta: float) -> void:
	grounded = is_on_floor()

	var direction := Input.get_axis("left", "right")

	# Running
	if Input.is_action_pressed("run_fire_decline"):
		speed_mult = RUN_SPEED_MULTIPLIER
		accel_mult = RUN_ACCEL_MULTIPLIER
	else:
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
		generate_skidding()

	# Ducking
	if powerup > 0:
		if Input.is_action_pressed("down_duck") and grounded:
			sprite.animation = "duck"
			if not ducking:
				set_powerup_collisions(true)
				ducking = true
			if not velocity.x == 0:
				generate_skidding()
		if Input.is_action_just_released("down_duck"):
			set_powerup_collisions(false)
			ducking = false

	# Jumping
	jump_mult = clamp(abs(velocity.x * (speed_mult - 1.0) / jumping_factor), 1.0, 1.25)
	
	if Input.is_action_just_pressed("jump_accept") and grounded and not ducking:
		velocity.y = JUMP_VELOCITY * jump_mult
		jump_sound.play()
		
	if Input.is_action_just_released("jump_accept") and not grounded and velocity.y < 0:
		if velocity.y < JUMP_VELOCITY_MIN * jump_mult:
			velocity.y = JUMP_VELOCITY_MIN * jump_mult
		else:
			velocity.y = 0
		
	# Horizontal Movement
	if direction and not ducking:
		velocity.x = clamp(velocity.x + direction * accel_mult * ACCELERATION, -SPEED * speed_mult, SPEED * speed_mult)	
	else:
		if abs(velocity.x) > DECELERATION:
			if velocity.x > 0:
				velocity.x -= DECELERATION
			elif velocity.x < 0:
				velocity.x += DECELERATION
		else:
			velocity.x = 0

	move_and_slide()

func generate_skidding():
	if not skid_sound.playing:
		skid_sound.play()
		var skid_effect = load("res://scenes/effects/skid_effect.tscn")
		var skid = skid_effect.instantiate()
		skid.position = position
		skid.position.y += 6.0
		add_sibling(skid)


@onready var collect_sound: AudioStreamPlayer2D = $channels/collect_sound


func coin_picker() -> void:
	collect_sound.play()
	
	
var powerup = 0
# 0: small, 1: big, 2: fire
const POWERUP_FRAMES = [
	preload("res://scenes/objects/resources/mario_small.tres"),
	preload("res://scenes/objects/resources/mario_big.tres")]
const POWERUP_OFFSETS = [0.0, -8.0]
@onready var collision_big_mid: CollisionShape2D = $collision_big_mid
@onready var collision_big_top: CollisionShape2D = $collision_big_top
@onready var shape_big: CollisionShape2D = $hitbox/shape_big

func powerup_picker(tier) -> void:
	if tier == 1 and powerup > 0 or powerup == tier:
		#powerup_same_sound.play()
		return
	else:
		#powerup_sound.play()
		set_powerup(tier)

func powerdown() -> void:
	if powerup > 1:
		set_powerup(1)
	elif powerup == 1:
		set_powerup(0)
	else:
		lose_life()

func set_powerup(tier) -> void:
	powerup = tier
	# animation here
	sprite.sprite_frames = POWERUP_FRAMES[tier]
	sprite.play()
	sprite.offset.y = POWERUP_OFFSETS[tier]
	if tier > 0:
		set_powerup_collisions(false)
	else:
		set_powerup_collisions(true)

func set_powerup_collisions(enabled) -> void:
	collision_big_mid.set_deferred("disabled", enabled)
	collision_big_top.set_deferred("disabled", enabled)
	shape_big.set_deferred("disabled", enabled)

func block_bumper() -> void:
	return


func lose_life():
	return
