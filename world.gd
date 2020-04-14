extends Node

onready var enemy = preload("res://enemy.tscn")
onready var enemy_container = get_node("enemy_container")

var screensize

func _ready():
	screensize = get_viewport().get_visible_rect().size
	set_process(true)
	
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load("res://kirby.wav")
	player.volume_db = -20
	player.play()
	
	spawn_enemies(1)
	
func spawn_enemies(num):
	for i in range(num):
		var einstance = enemy.instance()
		var e = einstance.get_child(0)
		enemy_container.add_child(einstance)
		e.set_position(Vector2(rand_range(0, screensize.x - 500), 305))

