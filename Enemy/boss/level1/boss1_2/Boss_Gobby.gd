extends KinematicBody2D
var speed = 50
var jump_speed = 150
var gravity = 200
var enemy_type = true
var phase1 = false
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
var phase_value = 90
var jump = false
onready var bullet_shoot = preload("res://Enemy/boss/level1/boss1_2/gobby_bullet.tscn")
onready var stalactite = preload("res://Enemy/boss/level1/boss1_2/Stalactite.tscn")
### sounds
onready var damage_hurt1_sound = preload("res://Enemy/gobby/sound/monster-1.wav")
onready var damage_hurt2_sound = preload("res://Enemy/gobby/sound/monster-2.wav")
onready var damage_hurt3_sound = preload("res://Enemy/gobby/sound/monster-3.wav")
onready var damage_hurt4_sound = preload("res://Enemy/gobby/sound/monster-4.wav")
onready var damage_hurt5_sound = preload("res://Enemy/gobby/sound/monster-5.wav")

var die_anim = 3
onready var death_sound = preload("res://Enemy/gobby/sound/monster-6.wav")
onready var idle_sound = preload("res://Enemy/gobby/sound/monster-8.wav")####
var start = false
var target
var visible_player = false
var melle_attack = false
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
	_move(delta)
	if start == true:
		
		phase()
		_animation()
		if target :
			aim()
		if jump == false and is_on_floor():
			if visible_player == true and melle_attack == false and target.direction.y == 0:
				_range_attack()

			elif visible_player == true and melle_attack == true and target.direction.y == 0 :
				range_attack = false
			elif visible_player == true and range_attack == false and melle_attack == false and target.direction.y == 1 :
				$spr.animation = "стойка"
				$damage_area/CollisionShape2D.disabled = true
			
		elif jump == true:
			if is_on_floor() and target.departure_down == true:
				target.elapsedtime = 0
				target.isShake = true
				target.shake_power = 5
				target.shake_time = 0.1
				var stal = stalactite.instance()
				stal.start(Vector2(rand_range(80,200),1250),150)
				get_parent().add_child(stal)
				var stal1 = stalactite.instance()
				stal1.start(Vector2(rand_range(80,200),1250),110)
				get_parent().add_child(stal1)
				var stal2 = stalactite.instance()
				stal2.start(Vector2(rand_range(80,200),1250),150)
				get_parent().add_child(stal2)
				var stal3 = stalactite.instance()
				stal3.start(Vector2(rand_range(80,200),1250),140)
				get_parent().add_child(stal3)
				var stal4 = stalactite.instance()
				stal4.start(Vector2(rand_range(200,400),1250),110)
				get_parent().add_child(stal4)
				var stal5 = stalactite.instance()
				stal5.start(Vector2(rand_range(200,400),1250),100)
				get_parent().add_child(stal5)
				var stal6 = stalactite.instance()
				stal6.start(Vector2(rand_range(200,400),1250),130)
				get_parent().add_child(stal6)
				var stal7 = stalactite.instance()
				stal7.start(Vector2(rand_range(200,400),1250),150)
				get_parent().add_child(stal7)
	else :
		 $spr.animation = "стойка"


func _animation():
	if direction.y > 0:
		if velocity.y < 0 :
			$spr.animation = "прыжок"
		if velocity.y > 0 :
			$spr.animation = "падение"
			
func phase():
	if php <= phase_value:
		jump = true
		target._damage(70)
		target.departure = true
		target.departure_down = false
		target.finish_departure = false
		$phase1.start()
		phase_value = phase_value - 15
func aim():
	direction = (target.position - position).normalized()
	if direction.x < 0 :
		$spr.flip_h = true
		$check_melle_attack_area.position.x = -8
		$damage_area.position.x = -8
		
	elif direction.x > 0:
		$spr.flip_h = false
		$check_melle_attack_area.position.x = 8
		$damage_area.position.x = 8

	
func _move(delta):
	
	if !is_on_floor():
		velocity.y += gravity*delta
	if is_on_floor() :
		velocity.y = 0
		if jump:
			velocity.y  = -jump_speed
			direction.y = 1
	
	move_and_slide(velocity, Vector2(0,-1))
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
	if randi()%8 == 0:
		print("parry")
		pass
	else:
		health_now -= damage
		var rand_damage_sound = [damage_hurt1_sound,damage_hurt2_sound]
		$damage_sound.stream = rand_damage_sound[randi()%2]
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
	if $spr.animation == "атака" and range_attack == true and melle_attack == false:
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
	if $spr.animation == "атака" and melle_attack == true and range_attack == false:
		if $spr.frame == 3:
			$damage_area/CollisionShape2D.disabled = false
		elif $spr.frame == 6:
			$damage_area/CollisionShape2D.disabled = true
		
	pass # Replace with function body.




func _on_check_melle_attack_area_body_entered(body):
	if body.get("player_type") == true:
		if jump == false:
			melle_attack = true
			$spr.animation = "атака"
			speed = 0
		elif jump == true:
			target.departure = true
			target.finish_departure = false
			target._damage(70)

	pass # Replace with function body.


func _on_check_melle_attack_area_body_exited(body):
	if body.get("player_type") == true:
		melle_attack = false
		speed = 0
		
	pass # Replace with function body.


func _on_damage_area_body_entered(body):
	if body.get("player_type") == true:
		body._damage(randi()%20+20)
	
	pass # Replace with function body.


func _on_Visible_body_entered(body):
	if body.get("player_type") == true:
		target = body
		start = true
		visible_player = true
	pass # Replace with function body.


func _on_phase1_timeout():
	jump = false
	target.isShake = false
	target.shake_power = 1
	target.shake_time = 0.1
	pass # Replace with function body.




func _on_Visible_body_exited(body):
	if body.get("player_type") == true:
		
		visible_player = false
		start = false
	pass # Replace with function body.



