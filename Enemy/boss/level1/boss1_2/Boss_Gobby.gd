extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health_now = 1000
### sounds
onready var damage_hurt2_sound = preload("res://sounds/sound effect/Socapex - blub_hurt2.wav")
####
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _settings():
	$music.volume_db = GLOBAL.music_value
	$attack_sound.volume_db = GLOBAL.sound_value
	$move_sound.volume_db = GLOBAL.sound_value
	$damage_sound.volume_db = GLOBAL.sound_value
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
#		"health" : health ,
#		"health_now" : health_now,
#		"php" : php,
		"name" : name,
		
	}
	return save_dict
	
func _damage(damage):
	health_now -= damage
	$damage_sound.stream = damage_hurt2_sound
	$damage_sound.play()