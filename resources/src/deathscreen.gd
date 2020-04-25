extends Node

const AUDIO = preload("res://resources/src/inc/Audio.gd")
onready var Audio = AUDIO.new()

func _ready():
	Audio.playFX(self, "death", -20)
