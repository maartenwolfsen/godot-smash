extends Node

func playStageTrack(node, sound, decibel = 0, ext = "wav"):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = load("res://resources/sound/music/stages/" + sound + "." + ext)
	play(audioPlayer, node, sound, decibel)

func playFX(node, sound, decibel = 0, ext = "wav"):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = load("res://resources/sound/fx/" + sound + "." + ext)
	play(audioPlayer, node, sound, decibel)

func play(player, node, sound, decibel = 0):
	player.volume_db = decibel
	node.add_child(player)
	player.play()
