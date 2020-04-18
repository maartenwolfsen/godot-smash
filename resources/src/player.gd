extends KinematicBody2D

signal health_updated(health)
signal killed()
signal knockback()

const P1ID = "1339"
const P2ID = "1354"

# Movement
const UP = Vector2(0, -1)
const MAX_SPEED = 150
const RUN_MAX_SPEED = 250
const ACCELERATION = 50
const RUN_ACCELERATION = 70
const GRAVITY = 10
const JUMP_HEIGHT = 200
const MAX_JUMP_HEIGHT = 500

var playerID = null

var motion = {}
var jumpAmount = 0
var attack_animation = false
#onready var audio = AudioStreamPlayer.new()

# Health
export (float) var percentage = 0

onready var health = percentage setget _set_health
onready var invulnerability_timer = $InvulnerabilityTimer

# Sprites
onready var kirbatjov = $fighterKirby

onready var attack_light_collision = $fighterKirby/attack_light_hit/CollisionShape2D
onready var attack_light_particles = $fighterKirby/attack_light_hit/attack_light_particles

onready var damageText = $damage_percentage
onready	var audio = AudioStreamPlayer.new()

func _physics_process(delta):
	if typeof(playerID) != TYPE_NIL && playerID != null:
		pass
	
	var instanceId = self.get_instance_id()
	
	if !motion.has(instanceId):
		motion[instanceId] = Vector2()
	
	self.add_child(audio)

	motion[instanceId].y += GRAVITY
	var friction = false
		
	# Attack
	#if Input.is_action_just_pressed() && is_on_floor() && !attack_animation:
		#audio.stream = load("res://resources/sounds/fx/attack_light.wav")
		#audio.play()
	#	kirbatjov.play("attack_light")
	#	attack_light_collision.disabled = false
	#	attack_light_particles.visible = true
	#	attack_light_particles.set_frame(0)
	#	attack_light_particles.play("attack_light_particles")
	#	attack_animation = true
	#if attack_light_particles.animation == "attack_light_particles" && attack_light_particles.frame == attack_light_particles.frames.get_frame_count("attack_light_particles") - 1:
	#	attack_animation = false
	#	attack_light_collision.disabled = true
	#	attack_light_particles.visible = false
	
	# Run direction / acceleration
	if Input.is_action_pressed("dir_right_p" + str(playerID)):
		if Input.is_action_pressed("run_p" + str(playerID)):
			motion[instanceId].x += RUN_ACCELERATION
			motion[instanceId].x = min(motion[instanceId].x + RUN_ACCELERATION, RUN_MAX_SPEED)
			
			if !attack_animation:
				kirbatjov.play("run")
		else:
			motion[instanceId].x += ACCELERATION
			motion[instanceId].x = min(motion[instanceId].x + ACCELERATION, MAX_SPEED)
			
			if !attack_animation:
				kirbatjov.play("walk")
		
		kirbatjov.flip_h = false
		attack_light_particles.flip_h = false
		attack_light_particles.set_offset(Vector2(0, 0))
	elif Input.is_action_pressed("dir_left_p" + str(playerID)):
		if Input.is_action_pressed("run_p" + str(playerID)):
			motion[instanceId].x -= RUN_ACCELERATION
			motion[instanceId].x = max(motion[instanceId].x - RUN_ACCELERATION, -RUN_MAX_SPEED)
			
			if !attack_animation:
				kirbatjov.play("run")
		else:
			motion[instanceId].x -= ACCELERATION
			motion[instanceId].x = max(motion[instanceId].x - ACCELERATION, -MAX_SPEED)
			
			if !attack_animation:
				kirbatjov.play("walk")
		
		kirbatjov.flip_h = true
		attack_light_particles.flip_h = true
		attack_light_particles.set_offset(Vector2(-680, 0))
	else:
		friction = true
		
		if !attack_animation:
			kirbatjov.play("idle")
	
	# Double jump
	if Input.is_action_just_pressed("dir_up_p" + str(playerID)) && jumpAmount < 1:
		if (motion[instanceId].y < MAX_JUMP_HEIGHT):
			motion[instanceId].y -= JUMP_HEIGHT
		
		jumpAmount += 1
		audio.stream = load("res://resources/sounds/fx/jump.wav")
		audio.play()
	
	# Sliding & jump / fall animation
	if is_on_floor():
		jumpAmount = 0
		
		if friction == true:
			motion[instanceId].x = lerp(motion[instanceId].x, 0, 0.2)
	else:		
		if motion[instanceId].y < 0:
			kirbatjov.play("jump")
		else:
			kirbatjov.play("falling")
		
		if friction == true:
			motion[instanceId].x = lerp(motion[instanceId].x, 0, 0.05)
	
	motion[instanceId] = self.move_and_slide(motion[instanceId], UP)
	
	pass
	
func damage(amount):
	if invulnerability_timer.is_stopped():
		_set_health(health - amount)
		invulnerability_timer.start()
		knockback()
		audio.stream = load("res://resources/sounds/fx/damage.wav")
		audio.play()
	
func kill():
	get_tree().change_scene("res://resources/scenes/deathscreen.tscn")
	pass

func _set_health(value):
	var prev_health = health
	health = ceil(health + (health / 4) + 5)
	
	damageText.set_text(str(health) + "%")
	
	if health != prev_health:
		emit_signal("health_updated", health)
		
		if health == 0:
			kill()
			emit_signal("killed")

#func _on_playerArea_area_entered(area):
#	damage(20)
#	print(health)
#	pass

func knockback():
	motion.x -= health * 15
	var ymot = 100 + (health * 3)
	
	if ymot > 400:
		ymot = 400
		
	motion.y -= ymot
	pass
	
func init(pID):
	playerID = pID
