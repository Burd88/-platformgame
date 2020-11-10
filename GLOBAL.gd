extends Node
var load_game 
var say_label = false
var say_text = ""
#var Player_health = 1000
# настройки звука
var music_value = -20
var sound_value = -20
var sound_off = false
var music_value_off
var sound_value_off
var paused = false
var platform = "MOBILE"# PC or MOBILE
var save_path = "user://savegame.save"
# var b = "text"
#onready var dead_scene = preload("res://Enemy/Dead_enemy.tscn")
#var position_enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	paused
	sound_value
	music_value
func player_dead():

	#var d = dead_scene.instance()
	#d.position = position_enemy
	#get_parent().add_child(d)
	pass


