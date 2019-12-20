extends KinematicBody2D

var speed = 150
var jump_speed = 150
var gravity = 230
var player_type = true
## жизни игрока
var health = 600
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
var strength = 10
var agility = 10
var skill_point = 0
var def_damage
var min_damage
var max_damage
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
onready var damage_wood_sound = preload("res://sounds/sound effect/wood_damage.wav")
## sound move 
onready var move_stone1_sound = preload("res://player/sound/sfx_step_grass_l.wav")
onready var move_stone2_sound = preload("res://player/sound/sfx_step_grass_r.wav")
## jump 
onready var jump1_sound = preload("res://player/sound/jump 1.wav")
onready var jump2_sound = preload("res://player/sound/jump 2.wav")
##damage self
onready var damage1_sound = preload("res://player/sound/damage-1.wav")
onready var damage2_sound = preload("res://player/sound/damage-2.wav")
##pick up items
onready var pick_up_item1_sound = preload("res://player/sound/pick-up-item-1.wav")
onready var pick_up_item2_sound = preload("res://player/sound/pick-up-item-2.wav")
##bottle drink
onready var bottle_drink_sound = preload("res://player/sound/bottle-drink.wav")
##
export var shake_power = 1
export var shake_time = 0.1
var isShake = false
var elapsedtime = 0

onready var arrow = preload("res://items/arrow/arrow.tscn")
var arrow_count = 5

var regen_hp = true


var departure = false
var departure_down = false
var finish_departure = true
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
var experience_next_level = 30

var hook_line_pos 
var hook_line_use = false
var hook_vector


var icon
var text
var use_index
var visible_potion = false

var lesser = false
var li
var minor = false
var mii
var norm = false
var ni
var big = false
var bi
var major = false
var mai

var rope_in_inventory = false

var weapon_inventory
var str_weapon = 0
var agi_weapon= 0
var hp_weapon= 0
var chest_inventory
var str_chest= 0
var agi_chest= 0
var hp_chest= 0
var gloves_inventory
var str_gloves= 0
var agi_gloves= 0
var hp_gloves= 0
var foot_inventory
var str_foot= 0
var agi_foot= 0
var hp_foot= 0
var feet_inventory
var str_feet= 0
var agi_feet= 0
var hp_feet= 0
var ring_inventory
var str_ring= 0
var agi_ring= 0
var hp_ring= 0
var neck_inventory
var str_neck= 0
var agi_neck= 0
var hp_neck= 0

var full_hp= 0


func _ready(): # стартовые переменные персонажа
#	if GLOBAL.load_game == "new_game":
#		position = Vector2(144,366)
#		pass
#	elif GLOBAL.load_game == "loading_game":
#		pass

	last_position_y = position.y
	set_physics_process(true)
	set_process(true)

func _expirience(): # получение опыта
	$GUI/Exp_bar/fg.value = experience
	$GUI/Exp_bar/fg.max_value = experience_next_level
	$GUI/level_bar/level.text = str(level)
	if experience == experience_next_level:
		$UI_paneli/Button_UI/Pinfo_button/AnimationPlayer.play("level_up")
		level +=1
		skill_point += 3
		experience = 0
		experience_next_level += level*3
	elif experience > experience_next_level:
		$UI_paneli/Button_UI/Pinfo_button/AnimationPlayer.play("level_up")
		level +=1
		skill_point += 3
		var miss_exp = experience - experience_next_level
		experience = experience - experience_next_level
		experience_next_level += level*3
func _settings():# настройки пока звук
	$music.volume_db = GLOBAL.music_value
	$fight_sound.volume_db = GLOBAL.sound_value
	$move_sound.volume_db = GLOBAL.sound_value
	$damage_sound.volume_db = GLOBAL.sound_value

func _physics_process(delta):# функция выполнения во время игры всех остальных функций
	update()
	_settings()
	
	if $spr.animation == "смерть":
		velocity.y += gravity*delta
		move_and_slide(velocity,Vector2(0,-1))
		pass
	else:
		if cut_scene == false and departure == false and hook_line_use == false:
#			inventory_use_button()
			_move(delta)
			_attack()
			visible_health_potion()
			$GUI/HPbar1.show()
			$Light2D.show()
			$GUI/Exp_bar.show()
			$GUI/level_bar.show()
			$Camera2D.current = true
			$UI_paneli/Button_UI.show()
			check_rope_inventory()
			if torch:
				$UI_paneli/Torch_light.show()
				

		elif cut_scene == true and departure == false and hook_line_use == false :
			
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
			$inventary/inventory/bag1.cursor_insideItemList = false
			$inventary/inventory.hide()
			$GUI/HPbar1.hide()
			$Light2D.hide()
			$GUI/say_label.hide()
			$UI_paneli/Health_potion.hide()
			$GUI/Exp_bar.hide()
			$GUI/level_bar.hide()
			$UI_paneli/Button_UI.hide()
			$Player_info/Statistics.hide()
			$Player_info/equip_panel.hide()
			$UI_paneli/Torch_light.hide()
		elif departure == true and hook_line_use == false :
			if finish_departure == false:
				$spr.animation = "departure"
				attack = false
				var departure_speed = 150
				velocity.x = +departure_speed
			elif finish_departure == true: 
				$spr.animation = "подъем"
				attack = false
			velocity.y += gravity*delta
			move_and_slide(velocity,Vector2(0,-1))
			
		elif hook_line_use:
			print(int(position.distance_to(hook_vector)))
			if position.distance_to(hook_vector) > 30:
				$spr.animation = "веревка_подъем"
				$Line2D.set_point_position(1 , hook_vector - $Line2D.global_position)
				var move_dist = (hook_vector - global_position).normalized()
				gravity = 0
				velocity +=35*move_dist*delta
				move_and_slide(velocity)
			elif position.distance_to(hook_vector) < 30:
				$spr.animation = "прыжок"
				$Line2D.set_point_position(1 ,   Vector2(0,0))
				hook_line_pos = null
				hook_vector = null
				gravity = 230
#				velocity.x = direction.x*30
				velocity.y -=100
				hook_line_use = false
		if hook_line_pos:
			if Input.is_action_pressed("use_button"):
				
				$Line2D.set_point_position(1 ,   hook_line_pos - $Line2D.global_position)
				velocity.x = 0
				velocity.y = 0
				$hook_line/CollisionShape2D.disabled = true
				hook_vector = hook_line_pos
				hook_line_use = true
		_expirience()
		_gui()
		_death()
		_light_mode()
		formula()
		_use()
		if isShake:
			_shake_camera(delta)
 
		if Input.is_action_pressed("ui_page_down"):
			experience +=20

func save(): # сохранение игры

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
		"strength" : strength,
		"agility" : agility,
		"skill_point" : skill_point,
		"level" : level,
		"experience" : experience,
		"experience_next_level" : experience_next_level,
		"last_position_y" : last_position_y,
		"weapon_inventory" : weapon_inventory,
		"chest_inventory" : chest_inventory,
		"gloves_inventory" : gloves_inventory,
		"foot_inventory" : foot_inventory,
		"feet_inventory" : feet_inventory,
		"ring_inventory" : ring_inventory,
		"neck_inventory" : neck_inventory,
	
	}
	
	return save_dict

func _departure():# функция отбрасывающая игрока
	$spr.animation = "departure"
	move_and_slide(Vector2(150,100))
	
	pass

func _move(delta):# движение игрока
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
		$hook_area.position.x = 9
#		$hook_line.position.x = 9
#		$hook_line.position.y = -77
		$Line2D.position.x = 7.5
		

	elif direction.x < 0:
		$spr.flip_h = true
		$attack_area.position.x = -16
		$use.position.x = -6
		$"E-key".position.x = - 14
		$use_check.position.x = -14
		$hook_area.position.x = -9
#		$hook_line.position.x = -9
#		$hook_line.position.y = -77
		$Line2D.position.x = -7.5

	
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
		$hook_line/CollisionShape2D.disabled = false
#		if velocity.x > 0:
#			$move_sound.stream = move_stone1_sound
#			$move_sound.play()
		floor_enable = true
		if last_position_y < (position.y-100):
			$fight_sound.stream = damage2_sound
			$fight_sound.play()
			health_now = health_now - (20*health)/100
			
		elif last_position_y < (position.y-200):
			health_now = health_now - (50*health)/100
			$fight_sound.stream = damage2_sound
			$fight_sound.play()
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

	if Input.is_action_just_pressed("ui_jump") and velocity.y >=0 and velocity.y <= 4 :
#		var jump_sound_rndm = randi()%2
#		if jump_sound_rndm == 0:
		$move_sound.stream = jump1_sound
		$move_sound.play()
#		elif jump_sound_rndm == 1:
#			$move_sound.stream = jump2_sound
#			$move_sound.play()
		velocity.y = -jump_speed
		direction.y = 1
	if hook_enable :
		$spr.animation = "зацеп"
		velocity.y = 0
		velocity.x = 0
		last_position_y = position.y

		if Input.is_action_just_pressed("ui_jump"):
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

func _damage(damage):# получение урона
	regen_hp = false
	$Regen_timer.start()
	if health_now >0 :
		if randi()%6 == parry:
			print("parry")
			pass
		else:
			if damage > 30 :
				$fight_sound.stream = damage2_sound
				$fight_sound.play()
			else :
				$fight_sound.stream = damage1_sound
				$fight_sound.play()
			health_now -= damage
	else: pass

func _use():# использование предмета
	if Input.is_action_just_pressed('use_button'):
		$use/CollisionShape2D.disabled = false
	else:
		$use/CollisionShape2D.disabled = true

func _light_mode():# включение света вокруг игрока
	if torch == true:
		$Light2D.texture_scale = 0.3
		$Light2D.energy = 1
		$Light2D.enabled = true
#		if Input.is_action_just_pressed("torch_throw"):
#
	else:
		$Light2D.texture_scale = 0.1
		$Light2D.enabled = true
		$Light2D.energy = 0.7
	pass

func move_camera(pos):# перемещение камеры для кат сцены 
	$Camera2D.global_position = pos
	$Camera2D/camera_light.enabled = true
	cut_scene = true
	$Camera2D/time_move.start()

func _on_time_move_timeout():# таймер перемещения камеры дял кат сцены
	$Camera2D.position = Vector2(0,0)
	$Camera2D/camera_light.enabled = false
	cut_scene = false
	pass # Replace with function body.

func _attack():# атака игрока
	
	if Input.is_action_just_pressed("ui_attack1") and !$inventary/inventory/bag1.cursor_insideItemList and !is_on_wall() and health_now > 0 and hook_enable == false and button == false: 
		#velocity.y = 0
		if attack == false:
			regen_hp = false
			$Regen_timer.start()
			attack = true
			
	else:
		#attack = false
		pass
	if attack and weapon == 1:
		$spr.speed_scale = 1 + (agility+agi_chest+agi_foot+agi_feet+agi_gloves+agi_neck+agi_ring+agi_weapon)*0.01/3
		$spr.animation = str(attack_name_sword[rand_attack_name_sword])
	elif attack and weapon == 0:
		$spr.speed_scale = 1 + (agility+agi_chest+agi_foot+agi_feet+agi_gloves+agi_neck+agi_ring+agi_weapon)*0.01/3
		$spr.animation = str(attack_name[rand_attack_name])
	elif !attack:
		$spr.speed_scale = 1
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
	pass

func _gui():# Графический интерфейс игрока
	if Input.is_action_just_pressed("open_inventory"):
		if $inventary/inventory.visible == true:
			$inventary/inventory.visible = false
		elif $inventary/inventory.visible == false:
			$inventary/inventory.visible = true
			
	if Input.is_action_just_pressed("player_info"):
		if $Player_info/Statistics.visible == true:
			$Player_info/Statistics.visible = false
		elif $Player_info/Statistics.visible == false:
			$Player_info/Statistics.visible = true
		if $Player_info/equip_panel.visible == true:
			$Player_info/equip_panel.visible = false
		elif $Player_info/equip_panel.visible == false:
			$Player_info/equip_panel.visible = true
	full_hp =health+hp_chest+hp_feet+hp_feet+hp_foot+hp_gloves+hp_ring+hp_ring+hp_neck+hp_weapon +((strength+str_chest+str_feet+str_foot+str_gloves+str_ring+str_neck+str_weapon)*5)
	php = (health_now*100)/full_hp

	$GUI/HPbar1/healthbar_pr.value = php
	if health_now > full_hp:
		health_now = full_hp

	
	$GUI/fps.text = str("FPS: ", Engine.get_frames_per_second())

	if health_now < full_hp and health_now > 0 and regen_hp == true:
		health_now += 0.07

func _on_Regen_timer_timeout():# таймер начала регенерации здоровья
	regen_hp = true
	pass # Replace with function body.

func _on_spr_animation_finished():# окончание анимации персонажа
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
	if $spr.animation == 'подъем':
		departure_down = true
		departure = false
		
	pass # Replace with function body.

func _death():# функция смерти игрока
	if health_now <= 0:
		death_true = true
		velocity = Vector2(0,150)
		health_now = 0
		$spr.animation = 'смерть'
		hook_enable = false
	pass

func _shake_camera(delta):# дрожаие камеры 
	if elapsedtime<shake_time:
		$Camera2D.offset =  Vector2(randf(), randf()) * shake_power
		elapsedtime += delta
	else:
		isShake = false
		elapsedtime = 0
		$Camera2D.offset = Vector2()   

func _on_attack_area_body_entered(body):# урон по цели 
	if body.get("enemy_type"):
		body._damage(damage)
#		elapsedtime = 0
#		isShake = true
		
	elif body.name == "frontground":
		if weapon == 1:
			$damage_sound.stream = damage_sword_sound
			$damage_sound.play()
		elif weapon == 0:
			$damage_sound.stream = damage_hand_sound
			$damage_sound.play()
	elif body.get("broken") == true:
		$damage_sound.stream = damage_wood_sound
		$damage_sound.play()
		if $spr.flip_h == true:
			body._damage_move(-1)
		elif  $spr.flip_h == false:
			body._damage_move(1)
		body.health -=1
	else : pass

	if !body:
		$attack_area/col_Atack.disabled = true

func formula():
	min_damage = 40+(strength+str_chest+str_feet+str_foot+str_gloves+str_ring+str_neck+str_weapon)*0.635+damage_sword
	max_damage = 90+(strength+str_chest+str_feet+str_foot+str_gloves+str_ring+str_neck+str_weapon)*0.63+damage_sword


func _on_spr_frame_changed():# изменение кадров анимации персонажа
	if $spr.animation == "бег" or $spr.animation == "бег_меч" or $spr.animation == "бег_меч_2" :
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
			damage = rand_range(min_damage,max_damage)

			$attack_area/col_Atack.disabled = false
		elif $spr.frame == 4:
			$attack_area/col_Atack.disabled = true
	
	elif $spr.animation == "удар_рукой_1" or $spr.animation == "удар_рукой_2" or $spr.animation == "удар_рукой_3":
		if $spr.frame == 1:
			$fight_sound.stream = figth_hand_sound
			$fight_sound.play()
			damage = rand_range(min_damage,max_damage)

			$attack_area/col_Atack.disabled = false
		elif $spr.frame == 3:
			$attack_area/col_Atack.disabled = true
	
	elif $spr.animation == "удар_ногой_1" or $spr.animation == "удар_ногой_2":
		if $spr.frame == 1 :
			$fight_sound.stream = figth_fit_sound
			$fight_sound.play()

			damage = rand_range(min_damage,max_damage)

			$attack_area/col_Atack.disabled = false
		elif $spr.frame == 3:
			$attack_area/col_Atack.disabled = true
	if  $spr.animation == "departure":
		if $spr.frame == 0:
			velocity.y = -jump_speed

		elif $spr.frame == 8:
			departure_down = true
			finish_departure = true
			
			

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

func _on_use_area_entered(area):# определение используемого предмета

	if area.get('data_id') != null:
		if randi()%2 == 0:
			$move_sound.stream = pick_up_item1_sound
			$move_sound.play()
		else: 
			$move_sound.stream = pick_up_item2_sound
			$move_sound.play()
	
		$inventary/inventory/bag1.update_slot(Global_Player.inventory_addItem(area.data_id))
		#print(area.data_id)
		area.queue_free()


	elif area.get("item_type") == "sword":
		equip_sword_anim = true
		$spr.animation = "меч_взял"

		damage_sword = area.damage
		weapon = 1
		area.queue_free()

	else: pass #print("no item")

#func inventory_use_button():# использование определенной ячейки инвенторя
#	if Input.is_action_just_pressed("1"):
#		inventory_check(0)
#		pass
#	elif Input.is_action_just_pressed("2"):
#		inventory_check(1)
#		pass
#	elif Input.is_action_just_pressed("3"):
#		inventory_check(2)
#		pass
#	elif Input.is_action_just_pressed("4"):
#		inventory_check(3)
#		pass
#	elif Input.is_action_just_pressed("5"):
#		inventory_check(4)
#		pass
#	elif Input.is_action_just_pressed("6"):
#		inventory_check(5)
#		pass
#	elif Input.is_action_just_pressed("7"):
#		inventory_check(6)
#		pass
#	elif Input.is_action_just_pressed("8"):
#		inventory_check(7)
#		pass
#	elif Input.is_action_just_pressed("9"):
#		inventory_check(8)
#		pass
#	elif Input.is_action_just_pressed("0"):
#		inventory_check(9)
#		pass
	pass

func visible_health_potion():#функци отображения используемой фласки
	for index in range(0, Global_Player.inventory_maxSlots):
		if $inventary/inventory/bag1.get_item_metadata(index)["type"] ==  "heal_potion" :
			if $inventary/inventory/bag1.get_item_metadata(index)["name"] ==  "LESSER_HEAL_POTION" :
				lesser = true
				li = index
			
			if $inventary/inventory/bag1.get_item_metadata(index)["name"] ==  "MINOR_HEAL_POTION" :
				minor = true
				mii = index
			
			if $inventary/inventory/bag1.get_item_metadata(index)["name"] ==  "HEAL_POTION" :
				norm = true
				ni = index
			
			if $inventary/inventory/bag1.get_item_metadata(index)["name"] ==  "BIG_HEAL_POTION" :
				big = true
				bi = index
		
			if $inventary/inventory/bag1.get_item_metadata(index)["name"] ==  "MAJOR_HEAL_POTION" :
				major = true
				mai = index
	if lesser == true:
		$UI_paneli/Health_potion.show()
		$UI_paneli/Health_potion/Icon.texture = load($inventary/inventory/bag1.get_item_metadata(li)["icon"])
		$UI_paneli/Health_potion/Label.text = $inventary/inventory/bag1.get_item_text(li)
		if Input.is_action_just_pressed("use_health_potion"):
			inventory_check(li)
	elif lesser == false and minor == true:
		$UI_paneli/Health_potion.show()
		$UI_paneli/Health_potion/Icon.texture = load($inventary/inventory/bag1.get_item_metadata(mii)["icon"])
		$UI_paneli/Health_potion/Label.text = $inventary/inventory/bag1.get_item_text(mii)
		if Input.is_action_just_pressed("use_health_potion"):
			inventory_check(mii)
	elif lesser == false and minor == false and norm == true:
		$UI_paneli/Health_potion.show()
		$UI_paneli/Health_potion/Icon.texture = load($inventary/inventory/bag1.get_item_metadata(ni)["icon"])
		$UI_paneli/Health_potion/Label.text = $inventary/inventory/bag1.get_item_text(ni)
		if Input.is_action_just_pressed("use_health_potion"):
			inventory_check(ni)
	elif lesser == false and minor == false and norm == false and big == true:
		$UI_paneli/Health_potion.show()
		$UI_paneli/Health_potion/Icon.texture = load($inventary/inventory/bag1.get_item_metadata(bi)["icon"])
		$UI_paneli/Health_potion/Label.text = $inventary/inventory/bag1.get_item_text(bi)
		if Input.is_action_just_pressed("use_health_potion"):
			inventory_check(bi)
	elif lesser == false and minor == false and norm == false and big == false and major == true:
		$UI_paneli/Health_potion.show()
		$UI_paneli/Health_potion/Icon.texture = load($inventary/inventory/bag1.get_item_metadata(mai)["icon"])
		$UI_paneli/Health_potion/Label.text = $inventary/inventory/bag1.get_item_text(mai)
		if Input.is_action_just_pressed("use_health_potion"):
			inventory_check(mai)
	elif lesser == false and minor == false and norm == false and big == false and major == false: 
		$UI_paneli/Health_potion.hide()

func inventory_check(index):# использование предмета инвенторе
	if $inventary/inventory/bag1.get_item_metadata(index)["type"] == "arrow":
		arrow_count += $inventary/inventory/bag1.arrow_count_random
		Global_Player.inventory_removeItem(index)
		$inventary/inventory/bag1.update_slot(index)
	elif $inventary/inventory/bag1.get_item_metadata(index)["name"] == "LESSER_HEAL_POTION":
		if  health_now < full_hp:
			$move_sound.stream = bottle_drink_sound
			$move_sound.play()
			var restore = randi()%100+100
			health_now += restore
			print($inventary/inventory/bag1.get_item_metadata(index)["name"])
			print(restore)
			
			Global_Player.inventory_removeItem(index)
			$inventary/inventory/bag1.update_slot(index)
			lesser = false
		elif health_now > full_hp:
			health_now = full_hp
		elif  health_now == full_hp:
			print("full hp")
			pass
	elif $inventary/inventory/bag1.get_item_metadata(index)["name"] == "MINOR_HEAL_POTION":
		if  health_now < full_hp:
			$move_sound.stream = bottle_drink_sound
			$move_sound.play()
			var restore = randi()%100+200
			health_now += restore
			print($inventary/inventory/bag1.get_item_metadata(index)["name"])
			print(restore)
			
			Global_Player.inventory_removeItem(index)
			$inventary/inventory/bag1.update_slot(index)
			minor = false
		elif health_now > full_hp:
			health_now = full_hp
		elif  health_now == full_hp:
			print("full hp")
			pass
	elif $inventary/inventory/bag1.get_item_metadata(index)["name"] == "HEAL_POTION":
		if  health_now < full_hp:
			$move_sound.stream = bottle_drink_sound
			$move_sound.play()
			var restore = randi()%100+300
			health_now += restore
			print($inventary/inventory/bag1.get_item_metadata(index)["name"])
			print(restore)
			Global_Player.inventory_removeItem(index)
			$inventary/inventory/bag1.update_slot(index)
			norm = false
		elif health_now > full_hp:
			health_now = full_hp
		elif  health_now == full_hp:
			print("full hp")
			pass
	elif $inventary/inventory/bag1.get_item_metadata(index)["name"] == "BIG_HEAL_POTION":
		if  health_now < full_hp:
			$move_sound.stream = bottle_drink_sound
			$move_sound.play()
			var restore = randi()%100+400
			health_now += restore
			print($inventary/inventory/bag1.get_item_metadata(index)["name"])
			print(restore)
			Global_Player.inventory_removeItem(index)
			$inventary/inventory/bag1.update_slot(index)
			big = false
		elif health_now > full_hp:
			health_now = full_hp
		elif  health_now == full_hp:
			print("full hp")
			pass
	elif $inventary/inventory/bag1.get_item_metadata(index)["name"] == "MAJOR_HEAL_POTION":
		if  health_now < full_hp:
			$move_sound.stream = bottle_drink_sound
			$move_sound.play()
			var restore = randi()%100+500
			health_now += restore
			print($inventary/inventory/bag1.get_item_metadata(index)["name"])
			print(restore)
			Global_Player.inventory_removeItem(index)
			$inventary/inventory/bag1.update_slot(index)
			major = false
		elif health_now > full_hp:
			health_now = full_hp
		elif  health_now == full_hp:
			print("full hp")
			pass
	pass
	
func check_rope_inventory():
	
	for index in range(0, Global_Player.inventory_maxSlots):
		if $inventary/inventory/bag1.get_item_metadata(index)["type"] ==  "rope" :
			
			rope_in_inventory = true
		
func _on_use_check_area_entered(area):# предмет в зоне использования
	#print(area.name)
	if area.get("useable") :
		
		$"E-key".show()
	else : pass

func _on_use_check_area_exited(area):# предмет вышел из зоны использования
	if area.get("useable") :
		$"E-key".hide()
	else : pass

func _on_use_check_body_entered(body):# тело в зоне использования
	#print(body.name)
	if body.get("useable") :
		$"E-key".show()
	else : pass

func _on_use_check_body_exited(body):# тело вышело из зоны использования
	if body.get("useable") :
		$"E-key".hide()
	else : pass

func _on_hook_area_area_entered(area):# предмет зацепа в зоне
	if area.get("type_hook") or area.get("hook_line"):
		attack = false
		hook_enable = true
		
	pass # Replace with function body.

func _on_hook_area_area_exited(area):# предмет зацепа вышел из зоны
	if area.get("type_hook") or area.get("hook_line"):
		hook_enable = false
	pass # Replace with function body.

func _on_Button_focus_entered():# фокус курсора на кнопке выключения диалога
	button = true
	pass # Replace with function body.

func _on_Button_focus_exited():# фокус курсора на кнопке выключения диалога
	button = false
	pass # Replace with function body.

func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.

func _on_hook_line_area_entered(area):
	if area.get("hook_line"):
		if rope_in_inventory == true:
			print(area.position)
			hook_line_pos = area.global_position
	pass # Replace with function body.

func _on_hook_line_area_exited(area):
	if area.get("hook_line"):
		hook_line_pos = null
		pass

	pass # Replace with function body.













func _on_use_body_entered(body):
	if body.get('data_id') != null and body.get("useable") == true:
		if randi()%2 == 0:
			$move_sound.stream = pick_up_item1_sound
			$move_sound.play()
		else: 
			$move_sound.stream = pick_up_item2_sound
			$move_sound.play()
	
		$inventary/inventory/bag1.update_slot(Global_Player.inventory_addItem(body.data_id))
		#print(area.data_id)
		body.queue_free()
	else: pass #print("no item")
	pass # Replace with function body.
