extends Node

var audioPlayer = AudioStreamPlayer.new()

func playFX(sound):
	self.add_child(audioPlayer)
	audioPlayer.stream = load("res://resources/sound/fx/" + sound + ".wav")
	audioPlayer.play()
	
	pass
