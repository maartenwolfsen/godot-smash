extends Node

func playStageTrack(node, sound, decibel = 0):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = load("res://resources/sound/music/stages/" + sound + ".wav")

func playFX(node, sound, decibel = 0):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = load("res://resources/sound/fx/" + sound + ".wav")
	play(audioPlayer, node, sound, decibel)

func play(player, node, sound, decibel = 0):
	player.volume_db = decibel
	node.add_child(player)
	player.play()
