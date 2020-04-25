extends Node

const PLAYER_MARGIN_X = 120
const PLAYER_MARGIN_Y = 80

const AUDIO = preload("res://resources/src/inc/Audio.gd")
onready var Audio = AUDIO.new()

onready var player_container = get_node("player_container")
onready var camera = get_node("smash_camera")
onready var hud = preload("res://resources/scenes/hud.tscn").instance()
var screensize

var players = {
	1: {
		"name": "bertus",
		"character": "fighter_kirby"
	},
	2: {
		"name": "harry",
		"character": "fighter_kirby"
	}
}

func _ready():
	screensize = self.get_viewport().size
	set_process(true)

	Audio.playStageTrack(self, "greens_greens", -20)
	
	for i in players:
		init_portrait(players[i], i)
		init_player(players[i], i)

func _process(delta):
	update_camera()	

func init_player(currentPlayer, i):
	var player = preload("res://resources/scenes/player.tscn").instance()
	player.get_child(0).init(i)
	player_container.add_child(player)
	player.get_child(0).set_position(Vector2(80 * i, 305))

func init_portrait(currentPlayer, i):
	var portrait = hud.find_node("p" + str(i) + "_portrait")
	portrait.texture = load(
		"res://resources/sprites/characters/" + currentPlayer.character + "/portrait/portrait.png"
	)
	
	var player_name = portrait.find_node("player_name")
	player_name.set_text(currentPlayer.name)
	portrait.visible = true
			
	camera.add_child(hud)

func update_camera():
	if player_container.get_child_count() <= 0:
		pass
	
	var i = 1
	for player in player_container.get_children():
		players[i].position = player.get_child(0).get_position()
		
		if (i > 1 && players[i].position.x < players[i - 1].position.x) || i == 1:
			players["minX"] = players[i].position.x
			
		if (i > 1 && players[i].position.x > players[i - 1].position.x) || i == 1:
			players["maxX"] = players[i].position.x
		
		if (i > 1 && players[i].position.y < players[i - 1].position.y) || i == 1:
			players["minY"] = players[i].position.y
			
		i += 1
	
	var leftX = players["minX"] - PLAYER_MARGIN_X
	var rightX = players["maxX"] + PLAYER_MARGIN_X
	
	screensize = get_viewport().get_visible_rect().size
	
	var deltaXpercentage = (rightX - leftX) / screensize.x
	
	#Set camera position
	var canvas_position = get_viewport().get_canvas_transform()
	camera.set_zoom(Vector2(deltaXpercentage, deltaXpercentage))
	canvas_position.origin = Vector2(
		leftX, players["minY"] - (PLAYER_MARGIN_Y * (1 + deltaXpercentage))
	)
	camera.set_transform(canvas_position)
	
	#Set hud position
	hud.set_scale(Vector2(pow(deltaXpercentage, 2), pow(deltaXpercentage, 2)))
