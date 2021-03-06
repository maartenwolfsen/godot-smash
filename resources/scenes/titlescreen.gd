extends Node2D

const AUDIO = preload("res://resources/src/inc/Audio.gd")
onready var Audio = AUDIO.new()

const CHARACTER = preload("res://resources/src/inc/character.gd")
onready var Character = CHARACTER.new()

var button_hover_scale = Vector2(1, 1)
var player_selection_turn = 1

onready var start_menu = get_node("start_menu")
onready var main_menu = get_node("main_menu")
onready var choose_character = get_node("choose_character")
onready var character_container = get_node("choose_character/character_container")

# Todo: player amount dynamically
var players_amount = 2

# Character selection
var character_selection_mode = false
var selection_pointer = 0
var selection_player = 1
var player_characters = {}

func _ready():
	Audio.playStageTrack(self, "startscreen", -20)

func _process(delta):
	# Player selection
	if character_selection_mode:
		var characters_amount = Character.get_characters_amount()
		
		if Input.is_action_just_pressed("dir_right_p1"):
			selection_pointer += 1
		elif Input.is_action_just_pressed("dir_left_p1"):
			selection_pointer -= 1
		elif Input.is_action_just_pressed("submit_p1"):
			var character = Character.get_character_by_key(selection_pointer)
			Audio.playFX(self, "ui/start")
			Audio.playCharacterSound(
				self, character + "_callout"
			)
			player_characters[selection_pointer] = {
				"name": str(selection_pointer) + "speler",
				"character": character
			}
			selection_player += 1
			
			if selection_player > players_amount:
				init_vs_game(players_amount, player_characters)
			
		if selection_pointer >= characters_amount:
			selection_pointer = 0
		elif selection_pointer < 0:
			selection_pointer = characters_amount - 1
	
		if character_container.get_child_count() > 0:
			# Reset outlines
			for portrait in character_container.get_children():
				if portrait.material != null:
					portrait.set_material(null)
			
			var portrait = character_container.get_child(selection_pointer)
			if portrait.material == null:
				var shader_mat = ShaderMaterial.new()
				shader_mat.shader = load(
					"res://resources/shaders/player_selection_outline_p" + str(selection_player) + ".shader"
				)
				portrait.set_material(shader_mat)
	
# Start
func _on_start_input_event(viewport, event, shape_idx):		
	if event is InputEventMouseButton && event.is_pressed():
		open_menu_state(start_menu, main_menu)

# VS mode
func _on_button_vs_input_event(viewport, event, shape_idx):		
	if event is InputEventMouseButton && event.is_pressed():
		open_menu_state(main_menu, choose_character)
		init_character_selection()
		character_selection_mode = true

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
	area.find_node("Sprite").scale = Vector2(
		button_hover_scale.x * 1.1, button_hover_scale.y * 1.1
	)
	
func button_hover_exited(area):
	area.find_node("Sprite").scale = Vector2(
		button_hover_scale.x, button_hover_scale.y
	)

func open_menu_state(old_state, new_state):
	Audio.playFX(self, "ui/start")
	old_state.visible = false
	new_state.visible = true

func init_vs_game(player_amount, player_characters):
	Globals.set("player_characters", player_characters)
	get_tree().change_scene("res://resources/scenes/world.tscn")
	pass

func init_character_selection():
	Audio.playFX(self, "ui/choose_character")
	
	var i = 0
	var characters = Character.get_characters()
	
	for character in characters:
		var c = characters[character]
		
		# Character Portraits
		var c_sprite = Sprite.new()
		c_sprite.texture = Character.get_character_portrait(c["name"])
		character_container.add_child(c_sprite)
		c_sprite.centered = false
		var c_pos = c_sprite.get_transform().origin
		c_sprite.transform.origin = Vector2(i * 80, c_pos.y)
		c_sprite.scale = Vector2(0.5, 0.5)
		
		i += 1
