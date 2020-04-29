extends Node2D

const AUDIO = preload("res://resources/src/inc/Audio.gd")
onready var Audio = AUDIO.new()

func _ready():
	Audio.playStageTrack(self, "startscreen", -20)

# Start game
func _on_start_input_event(viewport, event, shape_idx):		
	if event is InputEventMouseButton && event.is_pressed():
		Audio.playFX(self, "ui/start", -20)
		yield(get_tree().create_timer(0.2), "timeout")
		get_tree().change_scene("res://resources/scenes/world.tscn")
		pass


func _on_start_mouse_entered():
	self.find_node("start_button").set_modulate(Color(1, 1, 1, 1))


func _on_start_mouse_exited():
	self.find_node("start_button").set_modulate(Color(1, 1, 1, 0.78))
