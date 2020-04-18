extends Node

onready var player = preload("res://resources/scenes/player.tscn")
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
		var playerInstance = player.instance()
		var p = playerInstance.get_child(0)
		player_container.add_child(playerInstance)
		p.set_position(Vector2(rand_range(0, screensize.x - 500), 305))

