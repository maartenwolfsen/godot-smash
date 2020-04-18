extends Node

const NETWORK = preload("res://resources/src/inc/Network.gd")
onready var Network = NETWORK.new()

const AUDIO = preload("res://resources/src/inc/Audio.gd")
onready var Audio = AUDIO.new()

onready var player_container = get_node("player_container")

var screensize

func _ready():
	screensize = get_viewport().get_visible_rect().size
	set_process(true)

	Audio.playStageTrack(self, "greens_greens", -20)
	
	spawn_players(2)

func spawn_players(num):
	for i in range(num):
		var player = preload("res://resources/scenes/player.tscn").instance()
		var info = Network.self_data
		player.get_child(0).init(i + 1)
		player_container.add_child(player)
		player.get_child(0).set_position(Vector2(info.position.x + (80 * i), info.position.y))
		
