extends KinematicBody2D

var speed = 150
var jump_speed = 150
var gravity = 230
var player_type = true
## жизни игрока
var health = 500
var health_now = health
var php = (health_now*100)/health
##----------------------- 
var attack_name_sword = ['удар_мечом_1','удар_мечом_2','удар_мечом_3']
var rand_attack_name_sword = 1
var attack_name = ['удар_ногой_1','удар_ногой_2','удар_рукой_1','удар_рукой_2','удар_рукой_3']
var rand_attack_name = 1
var equip_sword_anim = false
var weapon = 0
var parry = 3
var damage
var damage_sword = 0
var last_position_y = 0
		# 0 = нет оружия
		# 1 = меч
		# 2 = лук
## sound load attack
onready var figth_hand_sound = preload("res://sounds/figth sound/animal melee sound.wav")
onready var figth_fit_sound = preload("res://sounds/figth sound/melee sound.wav")
onready var figth_sword_sound = preload("res://sounds/figth sound/sword sound.wav")


onready var damage_sword_sound = preload("res://sounds/sound effect/Socapex - Swordsmall.wav")
onready var damage_hand_sound = preload("res://sounds/sound effect/Socapex - big punch.wav")
## sound move attack
onready var move_stone1_sound = preload("res://player/sound/sfx_step_grass_l.wav")
onready var move_stone2_sound = preload("res://player/sound/sfx_step_grass_r.wav")

##
export var shake_power = 1
export var shake_time = 0.1
var isShake = false
var elapsedtime = 0

onready var arrow = preload("res://items/arrow/arrow.tscn")
var arrow_count = 5

var regen_hp = true
##
var health_potion = 0
var button = false
var swim = false
#var cont = 0
#var text_actual = null
#var shield = false
var open_door = false
var cut_scene = false
#var check_cell = false
var floor_enable = false
var distance = Vector2()
var velocity = Vector2()
var direction = Vector2()

var collision_info

var torch = false
var attack = false
#var wall = false
var inventory

##зацеп за стену
var hook_enable = false
var death_true = false
### expiriense 
var experience = 0
var level = 1
var experience_next_level = 100
func _ready():
#	$music.play()
	#$inventary/inventory/bag1.clear()
	last_position_y = position.y
	set_physics_process(true)
	set_process(true)
	#$inventary/inventory/bag1.load_items()
	#Global_Player.load_data()
func _expirience():
	$GUI/expirience.value = experience
	$GUI/expirience/level.text = str(level)
	if experience == experience_next_level:
		level +=1
		experience = 0
		
		
func _settings():
	$music.volume_db = GLOBAL.music_value
	$fight_sound.volume_db = GLOBAL.sound_value
	$move_sound.volume_db = GLOBAL.sound_value
	$damage_sound.volume_db = GLOBAL.sound_value
	
	
func _physics_process(delta):
	
	if $spr.animation == "смерть":
		pass
	else:
		
		#print(position.y)
			

#		bow_attack()
		_settings()
		if cut_scene == false:
			
			_move(delta)
			_attack()
			$inventary/inventory.show()
			$GUI/Healthbar.show()
			$Light2D.show()
		elif cut_scene == true:
			
			velocity.x = 0
			if is_on_floor():
				pass
			else: 
				velocity.y += gravity*delta
				collision_info = move_and_slide(velocity,Vector2(0,-1))
			if weapon == 0:
				$spr.animation = "стойка"
			elif weapon == 1:
				$spr.animation =  "стойка_меч_1"
			$inventary/inventory.hide()
			$GUI/Healthbar.hide()
			$Light2D.hide()
			$GUI/say_label.hide()
			#hide()
		_expirience()
		_gui()
		_death()
		_light_mode()
		_open_inventory()
		_use()
		if isShake:
			_shake_camera(delta)
 
		if Input.is_action_pressed("ui_page_down"):
			experience +=1
		
func save():
	
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"health" : health ,
		"health_now" : health_now,
		"weapon" : weapon,
		"torch" : torch,
		"name" : name,
		"damage_sword" : damage_sword,
		"parry" : parry,
	
	}

	return save_dict
	
func _move(delta):
	if health_now > 0 and attack == false and hook_enable == false: 
		direction.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	elif health_now <=0:
		direction.x = 0
	if direction.y > 0 and attack == false and !is_on_wall() and health_now > 0 and hook_enable == false:
		if velocity.y < 3.84 :
			if weapon == 0:
				
				$spr.animation = "прыжок"
				equip_sword_anim = false
				$CollisionShape2D.scale.y = 0.8
			elif weapon == 1:
				$spr.animation =  "прыжок_меч"
				equip_sword_anim = false
				$CollisionShape2D.scale.y = 0.8
		elif velocity.y > 3.84  :
			if weapon == 0:
				$spr.animation = "падение"
				$CollisionShape2D.scale.y = 1
			elif weapon == 1:
				$spr.animation =  "падение_меч"
				$CollisionShape2D.scale.y = 1
	if direction.y < 0 and attack == false and !is_on_wall() and health_now > 0 and hook_enable == false:
		if velocity.y <=3.84 and velocity.x == 0:
			$spr.animation = "присяд"
		elif velocity.y <=3.84 and velocity.x != 0:
			$spr.animation = "шаг_присяд"
		elif velocity.y > 3.84:
			if weapon == 0:
				$spr.animation = "падение"
			elif weapon == 1:
				$spr.animation =  "падение_меч"
	if direction.x != 0 and direction.y == 0 and open_door == false and attack == false and !is_on_wall() and health_now > 0 and hook_enable == false:
		if velocity.y == 0:
			if weapon == 0:
				$spr.animation = "бег"
				equip_sword_anim = false
			elif weapon == 1:
				$spr.animation =  "бег_меч"
				equip_sword_anim = false

		elif velocity.y > 0:
			if weapon == 0:
				$spr.animation = "падение"
			elif weapon == 1:
				$spr.animation =  "падение_меч"
	elif !equip_sword_anim and direction.x == 0 and direction.y == 0 and swim == false and open_door == false and attack == false and !is_on_wall() and health_now > 0 and hook_enable == false:
		if velocity.y == 0:
			if weapon == 0:
				$spr.animation = "стойка"
			elif weapon == 1:
				$spr.animation =  "стойка_меч_1"

		elif velocity.y > 3.84:
			if weapon == 0:
				$spr.animation = "падение"
			elif weapon == 1:
				$spr.animation =  "падение_меч"
	
	if direction.x > 0:
		$spr.flip_h = false
		$attack_area.position.x = 16
		$use.position.x = 6
		$"E-key".position.x = 14
		$use_check.position.x = 14
		$hook_area. position.x = 9

	elif direction.x < 0:
		$spr.flip_h = true
		$attack_area.position.x = -16
		$use.position.x = -6
		$"E-key".position.x = - 14
		$use_check.position.x = -14
		$hook_area. position.x = -9
	
	distance.x = speed*delta
	velocity.x = (direction.x*distance.x)/delta
	if !is_on_floor():
		velocity.y += gravity*delta

	
	if attack == false and hook_enable == false:
		collision_info = move_and_slide(velocity,Vector2(0,-1))
	elif attack == true:
		move_and_slide(Vector2(0, velocity.y))
		

	if velocity.y > 3.84:
		direction.y = 1
	
	
	if is_on_floor() :
		
#		if velocity.x > 0:
#			$move_sound.stream = move_stone1_sound
#			$move_sound.play()
		floor_enable = true
		if last_position_y < (position.y-100):
			health_now = health_now - (20*health)/100
			print("wow 20%")
		elif last_position_y < (position.y-200):
			health_now = health_now - (50*health)/100
			print("2")
		elif last_position_y < (position.y-300): 
			health_now = 0
		velocity.y = 0
		direction.y = 0
		last_position_y = position.y
		if Input.is_action_pressed("ui_down") and velocity.y >=0 and velocity.y <= 4 :

			direction.y = -1
			speed = 75
			$CollisionShape2D.position.y = 9
			$CollisionShape2D.scale.y = 0.7

		else:
			speed = 150
			$CollisionShape2D.position.y = 5
			$CollisionShape2D.scale.y =  1
	elif !is_on_floor():
		floor_enable = false

	if Input.is_action_just_pressed("ui_up") and velocity.y >=0 and velocity.y <= 4 :
		
		velocity.y = -jump_speed
		direction.y = 1
	if hook_enable :
		$spr.animation = "зацеп"
		velocity.y = 0
		velocity.x = 0

		if Input.is_action_just_pressed("ui_up"):
			hook_enable = false
			velocity.y = -jump_speed
			direction.y = 1
		if Input.is_action_just_pressed("ui_down"):
			hook_enable = false
			velocity.y = jump_speed
			direction.y = 1
		
	if is_on_ceiling():
		velocity.y = 0
		direction.y = 0
		if is_on_floor():
			$spr.animation = "присяд"
			direction.y = -1
	
	
func _damage(damage):
	regen_hp = false
	$Regen_timer.start()

	if randi()%6 == parry:
		print("parry")
		pass
	else:
		health_now -= damage

func _use():
	if Input.is_action_pressed('use_button'):
		$use/CollisionShape2D.disabled = false
	else:
		$use/CollisionShape2D.disabled = true

func _light_mode():
	if torch == true:
		$Light2D.enabled = true
	else:
		$Light2D.enabled = false
	pass

func _attack():
	
	if Input.is_action_just_pressed("ui_attack1") and !is_on_wall() and health_now > 0 and hook_enable == false and button == false: 
		#velocity.y = 0

		if attack == false:
			regen_hp = false
			$Regen_timer.start()
			attack = true
	else:
		#print("attack")
		#attack = false
		pass
	if attack and weapon == 1:
		$spr.animation = str(attack_name_sword[rand_attack_name_sword])
	elif attack and weapon == 0:
	
		$spr.animation = str(attack_name[rand_attack_name])
#	elif attack and weapon == 2 :
#		for i in range(0,Global_Player.inventory_maxSlots):
#			print($inventary/inventory/bag1.get_item_metadata(i))
#			if $inventary/inventory/bag1.get_item_metadata(i) == "Arrow":
#				$spr.animation = 'удар_лук'
##	elif attack and weapon == 2 
#			else:
#				print("arrow 0")
#				#weapon = 1
#			#	$spr.animation = "стойка"
#func bow_attack():
#	if Input.is_action_just_pressed("ui_bow_attack"):
#		var arrow_true = false
#		for i in range(0,Global_Player.inventory_maxSlots):
#			print($inventary/inventory/bag1.get_item_metadata(i))
#			if $inventary/inventory/bag1.get_item_metadata(i) == "Arrow":
#				arrow_true = true
#		if direction.x == 0 and Input.is_action_pressed("ui_bow_attack") and arrow_true:
#			$spr.animation = 'удар_лук'
#	else : $spr.animation = "стойка"
func _gui():		# Графический интерфейс игрока
	
	php = (health_now*100)/health
	if php > 75 and php <=100:
		$GUI/Healthbar/Sprite.texture = load("res://player/UI sprite/healthbar.png")
	elif php > 50 and php <=75:
		$GUI/Healthbar/Sprite.texture = load("res://player/UI sprite/healthbar75.png")
	elif php > 25 and php <=50:
		$GUI/Healthbar/Sprite.texture = load("res://player/UI sprite/healthbar50.png")
	elif php > 0 and php <=25:
		$GUI/Healthbar/Sprite.texture = load("res://player/UI sprite/healthbar25.png")
	elif php == 0:
		$GUI/Healthbar/Sprite.texture = load("res://player/UI sprite/healthbar0.png")
	$GUI/Healthbar.value = php
	$GUI/fps.text = str("FPS: ", Engine.get_frames_per_second())

	if health_now < health and health_now > 0 and regen_hp == true:
		health_now += 0.1
func _on_Regen_timer_timeout():
	regen_hp = true
	pass # Replace with function body.

func _on_spr_animation_finished():
	if $spr.animation == "удар_рукой_1" or $spr.animation == "удар_рукой_2" or $spr.animation == "удар_рукой_3" or $spr.animation == "удар_ногой_1" or $spr.animation == "удар_ногой_2" or $spr.animation == "удар_мечом_1" or $spr.animation == "удар_мечом_2" or $spr.animation == "удар_мечом_3":
		rand_attack_name_sword = randi()%3
		rand_attack_name = randi()%5
		#print("attack finish")
		attack = false
	elif $spr.animation == "меч_взял":
		equip_sword_anim = false
	if $spr.animation == 'смерть':
		#get_tree().change_scene("res://main/main.tscn")
		get_tree().change_scene("res://main/main.tscn")
		
		
	pass # Replace with function body.
	
func _death():
	if health_now <= 0:
		death_true = true
		velocity = Vector2(0,150)
		health_now = 0
		$spr.animation = 'смерть'
		hook_enable = false
	pass
	
func _shake_camera(delta):
	if elapsedtime<shake_time:
		$Camera2D.offset =  Vector2(randf(), randf()) * shake_power
		elapsedtime += delta
	else:
		isShake = false
		elapsedtime = 0
		$Camera2D.offset = Vector2()   

func _on_attack_area_body_entered(body):
	if body.get("enemy_type"):
		body._damage(damage)
		elapsedtime = 0
		isShake = true
		

		
		#print("body name: ", body.name)
	elif body.name == "frontground":
		if weapon == 1:
			$damage_sound.stream = damage_sword_sound
			$damage_sound.play()
		elif weapon == 0:
			$damage_sound.stream = damage_hand_sound
			$damage_sound.play()
	else : pass

	if !body:
		$attack_area/col_Atack.disabled = true


func _on_spr_frame_changed():
	if $spr.animation == "бег":
		if $spr.frame == 0:
			$move_sound.stream = move_stone1_sound
			$move_sound.play()
		elif $spr.frame == 3:
			$move_sound.stream = move_stone2_sound
			$move_sound.play()
		
	if $spr.animation == "удар_мечом_1" or $spr.animation == "удар_мечом_2" or $spr.animation == "удар_мечом_3":
		if $spr.frame == 1:
			$fight_sound.stream = figth_sword_sound
			$fight_sound.play()
			damage = randi()%20+50+damage_sword
			#print(damage)
			$attack_area/col_Atack.disabled = false
		elif $spr.frame == 4:
			$attack_area/col_Atack.disabled = true
	
	elif $spr.animation == "удар_рукой_1" or $spr.animation == "удар_рукой_2" or $spr.animation == "удар_рукой_3":
		if $spr.frame == 1:
			$fight_sound.stream = figth_hand_sound
			$fight_sound.play()
			damage = randi()%20+50
			#print(damage)
			$attack_area/col_Atack.disabled = false
		elif $spr.frame == 3:
			$attack_area/col_Atack.disabled = true
	
	elif $spr.animation == "удар_ногой_1" or $spr.animation == "удар_ногой_2":
		if $spr.frame == 1 :
			$fight_sound.stream = figth_fit_sound
			$fight_sound.play()
			damage = randi()%20+50
			#print(damage)
			$attack_area/col_Atack.disabled = false
		elif $spr.frame == 3:
			$attack_area/col_Atack.disabled = true

#	elif $spr.animation == "удар_лук" :
#		for i in range(0,Global_Player.inventory_maxSlots):
#			if $inventary/inventory/bag1.get_item_metadata(i) == "Arrow":
#				if $spr.frame == 7:
#			#	print("arrow start")
#					var a = arrow.instance()
#					if $spr.flip_h == false:
#			#	print("лево")
#						a.start((position+Vector2(15,5)),0)
#						get_parent().add_child(a)
#						Global_Player.inventory_removeItem(i)
#						$inventary/inventory/bag1.update_slot(i)
#					elif $spr.flip_h == true:
#			#	print("право")
#						a.start((position-Vector2(15,-5)),180)
#						get_parent().add_child(a)
#						Global_Player.inventory_removeItem(i)
#						$inventary/inventory/bag1.update_slot(i)
#			else: 
#				print("no arrow")
#				#$spr.animation = "стойка"
#				pass
#	else:
#		$attack_area/col_Atack.disabled = true
	
	
	pass # Replace with function body.

func _open_inventory():
	if Input.is_action_just_pressed("open_inventory") and $inventary/inventory.visible == false:
		$inventary/inventory.visible = true
	elif Input.is_action_just_pressed("open_inventory") and $inventary/inventory.visible == true:
		$inventary/inventory.visible = false

func _on_use_area_entered(area):
	if area.get('data_id') != null:
		$inventary/inventory/bag1.update_slot(Global_Player.inventory_addItem(area.data_id))
		#print(area.data_id)
		area.queue_free()
		pass

	elif area.get("item_type") == "sword":
		equip_sword_anim = true
		$spr.animation = "меч_взял"

		damage_sword = area.damage
		weapon = 1
		area.queue_free()

	else: pass #print("no item")

func _on_bag1_item_rmb_selected(index, at_position):
	if $inventary/inventory/bag1.get_item_metadata(index) == "arrow":
		arrow_count += $inventary/inventory/bag1.arrow_count_random
		Global_Player.inventory_removeItem(index)
		$inventary/inventory/bag1.update_slot(index)
	elif $inventary/inventory/bag1.get_item_metadata(index) == "leser_heal_potion":
		if  health_now < health:
			health_now += randi()%100+100
			Global_Player.inventory_removeItem(index)
			$inventary/inventory/bag1.update_slot(index)
		elif health_now > health:
			health_now = health
		elif  health_now == health:
			print("full hp")
			pass
	elif $inventary/inventory/bag1.get_item_metadata(index) == "minor_heal_potion":
		if  health_now < health:
			health_now += randi()%200+100
			Global_Player.inventory_removeItem(index)
			$inventary/inventory/bag1.update_slot(index)
		elif health_now > health:
			health_now = health
		elif  health_now == health:
			print("full hp")
			pass
	elif $inventary/inventory/bag1.get_item_metadata(index) == "heal_potion":
		if  health_now < health:
			health_now += randi()%300+100
			Global_Player.inventory_removeItem(index)
			$inventary/inventory/bag1.update_slot(index)
		elif health_now > health:
			health_now = health
		elif  health_now == health:
			print("full hp")
			pass
	elif $inventary/inventory/bag1.get_item_metadata(index) == "big_heal_potion":
		if  health_now < health:
			health_now += randi()%400+100
			Global_Player.inventory_removeItem(index)
			$inventary/inventory/bag1.update_slot(index)
		elif health_now > health:
			health_now = health
		elif  health_now == health:
			print("full hp")
			pass
	elif $inventary/inventory/bag1.get_item_metadata(index) == "major_heal_potion":
		if  health_now < health:
			health_now += randi()%500+100
			Global_Player.inventory_removeItem(index)
			$inventary/inventory/bag1.update_slot(index)
		elif health_now > health:
			health_now = health
		elif  health_now == health:
			print("full hp")
			pass

	pass # Replace with function body.


func _on_use_check_area_entered(area):
	#print(area.name)
	if area.get("useable") :
		
		$"E-key".show()
	else : pass


func _on_use_check_area_exited(area):
	if area.get("useable") :
		$"E-key".hide()
	else : pass



func _on_use_check_body_entered(body):
	#print(body.name)
	if body.get("useable") :
		$"E-key".show()
	else : pass


func _on_use_check_body_exited(body):
	if body.get("useable") :
		$"E-key".hide()
	else : pass


func _on_hook_area_area_entered(area):
	if area.get("type_hook"):
		hook_enable = true
	pass # Replace with function body.


func _on_hook_area_area_exited(area):
	if area.get("type_hook"):
		hook_enable = false
	pass # Replace with function body.


func _on_Button_focus_entered():
	button = true
	pass # Replace with function body.


func _on_Button_focus_exited():
	button = false
	pass # Replace with function body.


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.



