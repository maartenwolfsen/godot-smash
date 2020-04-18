extends Node

func _ready():
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load("res://resources/sounds/music/death.wav")
	player.volume_db = -10
	player.play()
