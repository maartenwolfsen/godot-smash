extends Node

const AUDIO_PATH_PREFIX = "res://resources/sound/"

func playStageTrack(node, sound, decibel = 0, ext = "wav"):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = load(AUDIO_PATH_PREFIX + "music/stages/" + sound + "." + ext)
	play(audioPlayer, node, sound, decibel)

func playFX(node, sound, decibel = 0, ext = "wav"):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = load(AUDIO_PATH_PREFIX + "fx/" + sound + "." + ext)
	play(audioPlayer, node, sound, decibel)

func playCharacterSound(node, sound, decibel = 0, ext = "wav"):
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = load(AUDIO_PATH_PREFIX + "characters/" + sound + "." + ext)
	play(audioPlayer, node, sound, decibel)

func play(player, node, sound, decibel = 0):
	player.volume_db = decibel
	node.add_child(player)
	player.play()
