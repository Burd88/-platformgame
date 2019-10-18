extends KinematicBody2D
var speed = 50
var jump_speed = 150
var gravity = 200
var enemy_type = true
var phase1 = true
var floor_in
## жизни игрока
var health = 2000
var health_now = health
var php = (health_now*100)/health
var range_attack = false
var damage
var attack_now = false
var shot_var = true
var distance = Vector2()
var velocity = Vector2()
var direction = Vector2(-1,0)
onready var bullet_shoot = preload("res://Enemy/boss/level1/boss1_2/gobby_bullet.tscn")
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
func _process(delta):
	_gui()
	_range_attack()

	pass
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
	
func _gui():# Графический интерфейс
	if health_now > 0 :
		$healthbar.show()
		#$HPlable.show()
	else:
		$healthbar.hide()
		#$HPlable.hide()
	#$HPlable.text = str(health, " / ", health_now )
	php = (health_now*100)/health
	$healthbar.value = php

func _range_attack():
	$spr.animation = "атака"
	range_attack = true
	pass
	

func _on_AnimatedSprite_frame_changed():
	if $spr.animation == "атака" and range_attack == true:
		if $spr.frame == 3:
			var b = bullet_shoot.instance()
			var flip
			if $spr.flip_h == true:
				flip = true
			elif $spr.flip_h == false:
				flip = false
			get_parent().add_child(b)
			if $spr.flip_h == true:
				b.start(position - Vector2(30,0), flip)
			elif $spr.flip_h == false:
				b.start(position + Vector2(30,0), flip)

			range_attack = false
		
	pass # Replace with function body.
