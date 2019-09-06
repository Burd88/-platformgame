extends KinematicBody2D

var speed = 150
var jump_speed = 150
var gravity = 230

## жизни игрока
var health = 1000
var health_now = health
var php = (health_now*100)/health
##----------------------- 
var attack_name_sword = ['удар_мечом_1','удар_мечом_2','удар_мечом_3']
var rand_attack_name_sword = 1
var attack_name = ['удар_ногой','удар_рукой']
var rand_attack_name = 1
var weapon = 1
var damage
		# 0 = нет оружия
		# 1 = меч
		# 2 = лук
##
onready var arrow = preload("res://items/arrow/arrow.tscn")
var arrow_count = 5
##
var health_potion = 0

var swim = false
#var cont = 0
#var text_actual = null
#var shield = false
var open_door = false

#var check_cell = false

var distance = Vector2()
var velocity = Vector2()
var direction = Vector2()

var collision_info

var torch = false

var attack = false
#var wall = false


func _ready():
	set_physics_process(true)
	set_process(true)

	
	#health_now = GLOBAL.Player_health

func _physics_process(delta):
	damage = randi()%100+50
	
	_move(delta)
	_attack()
	_gui()
	_death()
	_light_mode()
	use()
	use_health_potion()
	_open_inventory()

	#print(velocity.y)
	#print(velocity.y ," - ", direction.y)
#func save_levels():
	#var save_level = {
	#	"level" : get_parent().filename,
		
	#	}
	#return save_level

func save():
	
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"health" : health ,
		"health_now" : health_now,
		"php" : php,
		"weapon" : weapon,
		"damage" : damage,
		"arrow_count" : arrow_count,
		"health_potion" : health_potion,
		"torch" : torch,
		"name" : name
	}

	return save_dict
	
func _move(delta):
	if health_now > 0: 
		direction.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	elif health_now <=0:
		direction.x = 0
	if direction.y > 0 and attack == false and !is_on_wall() and health_now > 0:
		if velocity.y < 3.84 :
			if weapon == 0:
				$spr.animation = "прыжок"
			elif weapon == 1:
				$spr.animation =  "прыжок_меч"
		elif velocity.y > 3.84  :
			if weapon == 0:
				$spr.animation = "падение"
			elif weapon == 1:
				$spr.animation =  "падение_меч"
	if direction.y < 0 and attack == false and !is_on_wall() and health_now > 0:
		if velocity.y <=3.84 and velocity.x == 0:
			$spr.animation = "присяд"
		elif velocity.y <=3.84 and velocity.x != 0:
			$spr.animation = "шаг_присяд"
		elif velocity.y > 3.84:
			if weapon == 0:
				$spr.animation = "падение"
			elif weapon == 1:
				$spr.animation =  "падение_меч"
	if direction.x != 0 and direction.y == 0 and open_door == false and attack == false and !is_on_wall() and health_now > 0:
		if velocity.y == 0:
			if weapon == 0:
				$spr.animation = "бег"
			elif weapon == 1:
				$spr.animation =  "бег_меч_2"

		elif velocity.y > 0:
			if weapon == 0:
				$spr.animation = "падение"
			elif weapon == 1:
				$spr.animation =  "падение_меч"
	elif direction.x == 0 and direction.y == 0 and swim == false and open_door == false and attack == false and !is_on_wall() and health_now > 0:
		if velocity.y == 0:
			if weapon == 0:
				$spr.animation = "стойка"
			elif weapon == 1:
				$spr.animation =  "стойка_меч"

		elif velocity.y > 3.84:
			if weapon == 0:
				$spr.animation = "падение"
			elif weapon == 1:
				$spr.animation =  "падение_меч"

	if direction.x > 0:
		$spr.flip_h = false
		$attack_area.position.x = 18
		$use.position.x = 6
		$"E-key".position.x = 14

	elif direction.x < 0:
		$spr.flip_h = true
		$attack_area.position.x = -18
		$use.position.x = -6
		$"E-key".position.x = - 14
	
	distance.x = speed*delta
	velocity.x = (direction.x*distance.x)/delta
	#if !is_on_wall():
	velocity.y += gravity*delta
	
	collision_info = move_and_slide(velocity,Vector2(0,-1))
	
	#var get_col = get_slide_collision(get_slide_count()-1)
	
	if velocity.y > 3.84:
		direction.y = 1
	
	
	if is_on_floor() :
		
		velocity.y = 0
		direction.y = 0
	#	if Input.is_action_pressed("ui_down") and velocity.y >=0 and velocity.y <= 4 :
			
		#	direction.y = -1
		#	$CollisionShape2D.position.y = 9
	#		$CollisionShape2D.scale.y = 0.7
		
		#else:
		#	$CollisionShape2D.position.y = 5
		#	$CollisionShape2D.scale.y =  1

	if Input.is_action_just_pressed("ui_up") and velocity.y >=0 and velocity.y <= 4 :
		
		velocity.y = -jump_speed
		direction.y = 1

		
	

	#if !is_on_floor():
		#if is_on_wall() and direction.y == 1:
		#	velocity.y = 0
		#	wall = true
		#	$spr.animation = "hang1"
			#if Input.is_action_just_pressed("ui_up"):
			#	velocity.y = -jump_speed
			#	direction.y = 1
			#if Input.is_action_just_pressed("ui_down"):
			#	velocity.y = jump_speed
			#	direction.y = 1
		
	if is_on_ceiling():
		velocity.y = 0
		direction.y = 0
		if is_on_floor():
			$spr.animation = "присяд"
			direction.y = -1

	#if is_on_wall():
	#	print("wall")
	#elif is_on_floor():
	#	print("floor")
	#else:
	#	print("xz")

		
	
	
func use_health_potion():
	$GUI/health_potion_label/count.text = str(health_potion)
	if Input.is_action_just_pressed("use_health_potion"):
		if health_potion > 0 and health_now < health:
			health_potion -= 1
			health_now += 100
			if health_now > health:
				health_now = health
		elif health_potion > 0 and health_now == health:
			print("full hp")
		elif health_potion == 0:
			pass
		pass
func use():

	if Input.is_action_pressed('use_button'):
		$use/CollisionShape2D.disabled = false
	else:
		$use/CollisionShape2D.disabled = true

func _light_mode():
	if torch == true:
		$Light2D.enabled = true
		$GUI/Label.visible = false
	else:
		$Light2D.enabled = false
	pass
	
		
		
func _attack():
	if Input.is_action_pressed("ui_attack1") and !is_on_wall() and health_now > 0: 
		attack = true
	else:
		attack = false
	if attack and weapon == 1:
		$spr.animation = str(attack_name_sword[rand_attack_name_sword])
	elif attack and weapon == 0:
		$spr.animation = str(attack_name[rand_attack_name])
	elif attack and weapon == 2 and arrow_count >0:
		$spr.animation = 'удар_лук'
	elif attack and weapon == 2 and arrow_count <=0 :
		weapon = 1
		$spr.animation = "стойка"

func _gui():
	$GUI/HPlabel.text = str(health, " / ", health_now )
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
	$GUI/arrow.text = str("Arrow : ", arrow_count)
	#if health_now < health:
	#	health_now += 1
		# Графический интерфейс игрока

func _on_spr_animation_finished():
	if $spr.animation == "удар_рукой" or $spr.animation == "удар_ногой" or $spr.animation == "удар_мечом_1" or $spr.animation == "удар_мечом_2" or $spr.animation == "удар_мечом_3":
		rand_attack_name_sword = randi()%3
		rand_attack_name = randi()%2
	if $spr.animation == 'смерть':
		pause_menu.preload_game()
				#get_tree().change_scene("res://main/main.tscn")
	pass # Replace with function body.
	
func _death():
	if health_now <= 0:
		velocity = Vector2(0,150)
		health_now = 0
		$spr.animation = 'смерть'
	pass

func _on_attack_area_body_entered(body):
	if body.name == "Slime":
		body.health_now -= damage
	elif body.name != "Slime":
		for i in range(0, 10) :
			if body.name == str("Slime",+i) :
				body.health_now -=damage
			#print("sdas")
			
	if !body:
		$attack_area/col_Atack.disabled = true


func _on_spr_frame_changed():
	if $spr.animation == "удар_мечом_1" or $spr.animation == "удар_мечом_2" or $spr.animation == "удар_мечом_3":
		if $spr.frame == 1:
			$attack_area/col_Atack.disabled = false
		elif $spr.frame == 4:
			$attack_area/col_Atack.disabled = true
	#elif $spr.animation != "удар_мечом_1" or $spr.animation != "удар_мечом_2" or $spr.animation != "удар_мечом_3":
	#	$attack_area/col_Atack.disabled = true
	
	elif $spr.animation == "удар_рукой":
		if $spr.frame == 4 or $spr.frame == 8 or $spr.frame == 12:
			$attack_area/col_Atack.disabled = false
		elif $spr.frame == 1 or $spr.frame == 5 or $spr.frame == 9:
			$attack_area/col_Atack.disabled = true
	#elif $spr.animation != "удар_рукой":
	#	$attack_area/col_Atack.disabled = true
	
	elif $spr.animation == "удар_ногой":
		if $spr.frame == 2 or $spr.frame == 5 :
			$attack_area/col_Atack.disabled = false
		elif $spr.frame == 0 or $spr.frame == 4 or $spr.frame == 7:
			$attack_area/col_Atack.disabled = true
	#elif $spr.animation != "удар_ногой":
	elif $spr.animation == "удар_лук" :
		if $spr.frame == 7 and arrow_count > 0:
		#	print("arrow start")
			var a = arrow.instance()
			if $spr.flip_h == false:
			#	print("лево")
				a.start((position+Vector2(15,5)),0)
				get_parent().add_child(a)
				arrow_count -=1
			elif $spr.flip_h == true:
			#	print("право")
				a.start((position-Vector2(15,-5)),180)
				get_parent().add_child(a)
				arrow_count -=1
		elif $spr.frame == 2 and arrow_count <=0:
		#	print("no arrow")
			$spr.animation = "стойка"
			pass
	else:
		$attack_area/col_Atack.disabled = true
	
	
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.name == 'door':
		body.open = true
	#	print("door open")
		
	pass # Replace with function body.

func _open_inventory():
	if Input.is_action_just_pressed("open_inventory") and $inventary/inventory.visible == false:
		$inventary/inventory.visible = true
		#print($inventary/inventory/bag1.get_item_icon(0))
	elif Input.is_action_just_pressed("open_inventory") and $inventary/inventory.visible == true:
		$inventary/inventory.visible = false



func _on_use_area_entered(area):
	if area.name == "Arrow" or  area.name == "Health_potion":
		#print(area.name)
		var item_count = $inventary/inventory/bag1.get_item_count()

		if item_count < 4:
			$inventary/inventory/bag1.add_item("",area.icon)
			$inventary/inventory/bag1.set_item_metadata(item_count,area.metadata)
			area.queue_free()
	
	pass # Replace with function body.

	#if area:

	#if area.name == 'Gear6':
	#	print("шестерня на месте")
	#	area.visible = true
		
	#elif area.name == 'lever':
	#	area.use_lever = true
	#	print('Рычаг использован')
	#pass # Replace with function body.



func _on_bag1_item_selected(index):
	#print($inventary/inventory/bag1.get_item_count())
	#print(index)
	#print($inventary/inventory/bag1.get_item_metadata(index))
	if $inventary/inventory/bag1.get_item_metadata(index) == "arrow":
		
		#print($inventary/Panel/ItemList.arrow_count_random)
	#	print("arrow")
		arrow_count += $inventary/inventory/bag1.arrow_count_random
		$inventary/inventory/bag1.remove_item(index)
	pass # Replace with function body.


func _on_use_body_entered(body):
	if body.name == "Arrow":
		#print(body.name)
		var item_count = $inventary/inventory/bag1.get_item_count()

		if item_count < 4:
			$inventary/inventory/bag1.add_item("",body.icon)
			$inventary/inventory/bag1.set_item_metadata(item_count,body.metadata)
			body.queue_free()
	pass # Replace with function body.


func _on_bag1_item_rmb_selected(index, at_position):
	#print($inventary/inventory/bag1.get_item_count())
	#print(index)
	#print(at_position)
	#print($inventary/inventory/bag1.get_item_metadata(index))
	if $inventary/inventory/bag1.get_item_metadata(index) == "arrow":
		
		#print($inventary/Panel/ItemList.arrow_count_random)
	#	print("arrow")
		arrow_count += $inventary/inventory/bag1.arrow_count_random
		$inventary/inventory/bag1.remove_item(index)
	elif $inventary/inventory/bag1.get_item_metadata(index) == "Health_potion":
		if  health_now < health:
			health_potion -= 1
			health_now += 100
			$inventary/inventory/bag1.remove_item(index)
			if health_now > health:
				health_now = health
			elif  health_now == health:
				#print("full hp")
				pass
	pass # Replace with function body.
