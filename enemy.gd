extends KinematicBody2D

# Movement
const UP = Vector2(0, -1)
const MAX_SPEED = 150
const RUN_MAX_SPEED = 250
const ACCELERATION = 50
const RUN_ACCELERATION = 70
const GRAVITY = 10
const JUMP_HEIGHT = 200
const MAX_JUMP_HEIGHT = 500

var motion = Vector2()
var jumpAmount = 0
var attack_animation = false

# Sprites
onready var throwKirby = $throwKirby

func _physics_process(delta):
	var player = AudioStreamPlayer.new()
	self.add_child(player)

	motion.y += GRAVITY
	var friction = false
	
	
	# Run direction / acceleration
	if Input.is_action_pressed("p2_right"):
		if Input.is_action_pressed("action_run"):
			motion.x += RUN_ACCELERATION
			motion.x = min(motion.x + RUN_ACCELERATION, RUN_MAX_SPEED)
			
			if !attack_animation:
				throwKirby.play("run")
		else:
			motion.x += ACCELERATION
			motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
			
			if !attack_animation:
				throwKirby.play("walk")
		
		throwKirby.flip_h = false
		throwKirby.get_child(0).set_position(Vector2(350, 0))
	elif Input.is_action_pressed("p2_left"):
		if Input.is_action_pressed("action_run"):
			motion.x -= RUN_ACCELERATION
			motion.x = max(motion.x - RUN_ACCELERATION, -RUN_MAX_SPEED)
			
			if !attack_animation:
				throwKirby.play("run")
		else:
			motion.x -= ACCELERATION
			motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
			
			if !attack_animation:
				throwKirby.play("walk")
		
		throwKirby.flip_h = true
		throwKirby.get_child(0).set_position(Vector2(-350, 0))
	else:
		friction = true
		
		if !attack_animation:
			throwKirby.play("idle")
	
	# Double jump
	if Input.is_action_just_pressed("p2_up") && jumpAmount < 1:
		if (motion.y < MAX_JUMP_HEIGHT):
			motion.y -= JUMP_HEIGHT
		
		jumpAmount += 1
		player.stream = load("res://sounds/jump.wav")
		player.play()
	
	# Sliding & jump / fall animation
	if is_on_floor():
		jumpAmount = 0
		
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	else:		
		if motion.y < 0:
			throwKirby.play("jump")
		else:
			throwKirby.play("falling")
		
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)

	motion = move_and_slide(motion, UP)
	
	pass
