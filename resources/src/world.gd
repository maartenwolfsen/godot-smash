extends Node

const NETWORK = preload("res://resources/src/inc/Network.gd")
onready var Network = NETWORK.new()

const AUDIO = preload("res://resources/src/inc/Audio.gd")
onready var Audio = AUDIO.new()

onready var player_container = get_node("player_container")

const PLAYER_MARGIN_X = 40
const PLAYER_MARGIN_Y = 50
var screensize

func _ready():
	screensize = self.get_viewport().size
	set_process(true)

	Audio.playStageTrack(self, "greens_greens", -20)
	
	spawn_players(2)

func _process(delta):
	update_camera()

func spawn_players(num):
	for i in range(num):
		var player = preload("res://resources/scenes/player.tscn").instance()
		var info = Network.self_data
		player.get_child(0).init(i + 1)
		player_container.add_child(player)
		player.get_child(0).set_position(Vector2(info.position.x + (80 * i), info.position.y))

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
	
	var maxY = max(player1pos.y, player2pos.y) - (PLAYER_MARGIN_Y * (1 + deltaXpercentage))
	
	var camera = get_node("Camera2D")
	
	var canvas_position = get_viewport().get_canvas_transform()
	camera.set_zoom(Vector2(deltaXpercentage, deltaXpercentage))
	canvas_position.origin = Vector2(leftX, maxY)
	camera.set_transform(canvas_position)
	#get_viewport().set_canvas_transform(canvas_position)
