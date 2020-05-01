extends Node2D

const AUDIO = preload("res://resources/src/inc/Audio.gd")
onready var Audio = AUDIO.new()

const JSONLIB = preload("res://resources/src/inc/json.gd")
onready var Json = JSONLIB.new()

var button_hover_scale = Vector2(1, 1)

onready var start_menu = get_node("start_menu")
onready var main_menu = get_node("main_menu")
onready var choose_character = get_node("choose_character")
onready var character_container = get_node("choose_character/character_container")

func _ready():
	Audio.playStageTrack(self, "startscreen", -20)

# Start
func _on_start_input_event(viewport, event, shape_idx):		
	if event is InputEventMouseButton && event.is_pressed():
		Audio.playFX(self, "ui/start")
		main_menu.visible = true
		start_menu.visible = false

# VS mode
func _on_button_vs_input_event(viewport, event, shape_idx):		
	if event is InputEventMouseButton && event.is_pressed():
		Audio.playFX(self, "ui/start")
		choose_character.visible = true
		main_menu.visible = false
		Audio.playFX(self, "ui/choose_character")
		
		init_characters()

# Button hovers
func _on_start_mouse_entered(): button_hover_entered(self)
func _on_start_mouse_exited(): button_hover_exited(self)
func _on_button_vs_mouse_entered(): button_hover_entered(self)
func _on_button_vs_mouse_exited(): button_hover_exited(self)
func _on_button_options_mouse_entered(): button_hover_entered(self)
func _on_button_options_mouse_exited(): button_hover_exited(self)
func _on_button_data_mouse_entered(): button_hover_entered(self)
func _on_button_data_mouse_exited(): button_hover_exited(self)

func button_hover_entered(area):
	button_hover_scale = area.find_node("Sprite").scale
	area.find_node("Sprite").scale = Vector2(button_hover_scale.x * 1.1, button_hover_scale.y * 1.1)
	
func button_hover_exited(area):
	area.find_node("Sprite").scale = Vector2(button_hover_scale.x, button_hover_scale.y)
	
func init_characters():
	var characters = Json.read_file('data/characters')
	var i = 0
	
	for character in characters:
		var c = characters[character]
		
		# Character Portraits
		var c_sprite = Sprite.new()
		c_sprite.texture = load("res://resources/sprites/characters/" + c["name"] + "/portrait.png")
		character_container.add_child(c_sprite)
		c_sprite.centered = false
		var c_pos = c_sprite.get_transform().origin
		c_sprite.transform.origin = Vector2(i * 80, c_pos.y)
		c_sprite.scale = Vector2(0.5, 0.5)
		
		i += 1
