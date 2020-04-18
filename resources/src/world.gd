extends Node

const NETWORK = preload("res://resources/src/Network.gd")

onready var Network = NETWORK.new()
onready var player_container = get_node("player_container")

var screensize

func _ready():
	screensize = get_viewport().get_visible_rect().size
	set_process(true)
	
	var audioPlayer = AudioStreamPlayer.new()
	self.add_child(audioPlayer)
	audioPlayer.stream = load("res://resources/sounds/music/stages/greens_greens.wav")
	audioPlayer.volume_db = -20
	audioPlayer.play()
	
	spawn_players(2)

func spawn_players(num):
	for i in range(num):
		var player = preload("res://resources/scenes/player.tscn").instance()
		var networkUniqueId = get_tree().get_network_unique_id()
		player.name = str(networkUniqueId)
		player.set_network_master(networkUniqueId)
		var info = Network.self_data
		player.get_child(0).init(i + 1)
		player_container.add_child(player)
		player.get_child(0).set_position(Vector2(info.position.x + (80 * i), info.position.y))
		
