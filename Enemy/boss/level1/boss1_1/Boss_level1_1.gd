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
##----------------------- 
var anim = 'move'
onready var enemy_shoot = preload("res://Enemy/Slime/Slime.tscn")
onready var bullet_shoot = preload("res://Enemy/Slime/bullet.tscn")
### sounds
onready var damage_hurt2_sound = preload("res://sounds/sound effect/Socapex - blub_hurt2.wav")

####

onready var big_heal_potion = preload("res://items/Items/health_potion/big_heal_potion.tscn")
onready var heal_potion = preload("res://items/Items/health_potion/heal_potion.tscn")
onready var lesser_heal_potion = preload("res://items/Items/health_potion/leser_heal_potion.tscn")
onready var major_heal_potion = preload("res://items/Items/health_potion/major_heal_potion.tscn")
onready var minor_heal_potion = preload("res://items/Items/health_potion/minor_heal_potion.tscn")
onready var arrow_item = preload("res://items/Items/Arrow.tscn")
onready var gear_item = preload("res://items/Items/Gear/Gear.tscn")
onready var exp_point = preload("res://items/exp_point/Exp_point.tscn")
onready var chest_loot = preload("res://items/chest/Chest_black.tscn")
var enemy_shoot_count = 6
var damage
var attack_now = false
var shot_var = true
var distance = Vector2()
var velocity = Vector2()
var direction = Vector2(-1,0)
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
	_settings()
	_gui()
	_flip_move()
	fight()
	_death()
	
	distance.x = speed
	velocity.x = (direction.x*distance.x)
	if phase1 == true:
		velocity.y += gravity*delta
	elif phase1 == false:
		velocity.y -= gravity*delta
		
	move_and_slide(velocity,Vector2(0,-1))
	pass
#	pass

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"health" : health ,
		"health_now" : health_now,
		"php" : php,
		"name" : name,
	}
	return save_dict
func _damage(damage):
	health_now -= damage
	$damage_sound.stream = damage_hurt2_sound
	$damage_sound.play()

func _flip_move():
	if is_on_wall():
		direction.x =direction.x*(-1)
		if $spr.flip_h == true:
			$spr.flip_h = false
		elif $spr.flip_h == false:
			$spr.flip_h = true
			
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
	if php < 50 and enemy_shoot_count > 0:
		phase1 = false
	elif php < 50 and enemy_shoot_count == 0:
		phase1 = true
		
		

func _drop_item():
	var item_drop = randi()%2
	for i in randi()%3+7:
		var item = exp_point.instance()
		get_parent().add_child(item)
		item.position_start = position + Vector2(rand_range(-70,70),rand_range(-30,-70))
		item.position = position
	print(item_drop)
	var gear_loot = gear_item.instance()
	get_parent().add_child(gear_loot)
	gear_loot.position = position+Vector2(-16,0)


	

	
func fight():

	if is_on_ceiling():
		velocity.y = 0
		direction.y = 0
		$spr.flip_v = true
		$spr.offset.y = 10
		floor_in  = false
		if shot_var == true:
			
			$shot.start()
			shot_var = false
			#print("enemy timer start")
	elif is_on_floor():
		velocity.y = 0
		direction.y = 0
		$spr.flip_v = false
		$spr.offset.y = 0
		floor_in = true
		if shot_var == true and attack_now:
			$bullet.start()
			shot_var = false
			#print("bullet timer start")
	pass

func _on_shot_timeout():
	if !floor_in:
		var b = enemy_shoot.instance()
		get_parent().get_parent().get_parent().add_child(b)
		b.position = position + Vector2(0 , 30)
		b.get_node("sprite").speed_scale = 0.7
		b.health = 200
		b.health_now = 200
		b.damage = 30
		if enemy_shoot_count >= 0:
			enemy_shoot_count -=1
		else: pass
		$shot.start()
		#print("rnrmy timer finish")
		shot_var = true
	else: 
		#print("timer finish and lose")
		shot_var = true
		pass
	pass # Replace with function body.



func _on_phase1_timeout():
	
	if !phase1:
		phase1 = true
	elif phase1:
		phase1 = false
	pass # Replace with function body.
	
func _death():
	if health_now <= 0:
		health_now = 0
		$spr.animation = "die"
		velocity = Vector2(0,0)
		


func _on_bullet_timeout():
	if floor_in:
		var b = bullet_shoot.instance()
		var c = bullet_shoot.instance()
		get_parent().add_child(b)

		b.start((position - Vector2(0 , 5)), 5,100)

		get_parent().add_child(c)
		c.start((position - Vector2(0 , 5)), -5,-100)
		
		$bullet.start()
		#print("bullet timer finish")
		shot_var = true
	else: 
		#print("timer finish and lose")
		shot_var = true
		pass
	pass # Replace with function body.
	pass # Replace with function body.


func _on_spr_animation_finished():
	if $spr.animation == "die" : 
		_drop_item()
		get_parent().get_parent().get_parent().boss1_1_kill = true
		get_parent().get_node("Chest").show()
		queue_free()
		
		
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.get("player_type"):
		#direction = (body.position-position).normalized()
		pass
	pass # Replace with function body.
