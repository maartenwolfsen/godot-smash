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
		init_player(players[i], i)
		init_portrait(players[i], i)

func _process(delta):
	update_camera()	

func init_player(currentPlayer, i):
	var player = preload("res://resources/scenes/player.tscn").instance()
	player.get_child(0).init(i)
	player_container.add_child(player)
	player.get_child(0).set_position(Vector2(80 * i, 305))

func init_portrait(currentPlayer, i):
	var portrait = hud.find_node("p" + str(i) + "_portrait")
	portrait.find_node("portrait").texture = load(
		"res://resources/sprites/characters/" + currentPlayer.character + "/portrait/portrait.png"
	)
	
	var player_name = portrait.find_node("player_name")
	player_name.set_text(currentPlayer.name)
	player_name.margin_left = 20
	player_name.margin_top = 20
	portrait.visible = true
			
	camera.add_child(hud)

func update_camera():
	if player_container.get_child_count() <= 0:
		pass
	
	var player1 = player_container.get_child(0)
	var player1pos = player1.get_child(0).get_position()
	
	var player2 = player_container.get_child(1)
	var player2pos = player2.get_child(0).get_position()
	
	var leftX = min(player1pos.x, player2pos.x) - PLAYER_MARGIN_X
	var rightX = max(player1pos.x, player2pos.x) + PLAYER_MARGIN_X
	var deltaX = rightX - leftX
	
	screensize = get_viewport().get_visible_rect().size
	
	var deltaXpercentage = deltaX / screensize.x
	var deltaXrate = 1 + deltaXpercentage
	
	var maxY = min(player1pos.y, player2pos.y) - (PLAYER_MARGIN_Y * deltaXrate)
	
	#Set camera position
	var canvas_position = get_viewport().get_canvas_transform()
	camera.set_zoom(Vector2(deltaXpercentage, deltaXpercentage))
	canvas_position.origin = Vector2(leftX, maxY)
	camera.set_transform(canvas_position)
	
	#Set hud position
	hud.set_scale(Vector2(pow(deltaXpercentage, 2), pow(deltaXpercentage, 2)))
