extends KinematicBody2D

var speed = 150
var jump_speed = 150
var gravity = 230

## жизни игрока
var health = 1000
var health_now = health-500
var php = (health_now*100)/health
##----------------------- 
var attack_name = ['attack1','attack2','attack3']
var rand_attack_name = 1
##
var damage = randi()%100+50


var swim = false
#var cont = 0
#var text_actual = null
#var shield = false
var open_door = false

var check_cell = false

var distance = Vector2()
var velocity = Vector2()
var direction = Vector2()

var collision_info



var attack = false
var wall = false


func _ready():
	set_physics_process(true)
	set_process(true)
	health_now = GLOBAL.Player_health

func _physics_process(delta):
	_move(delta)
	_attack()
	_gui()
	_death()
	
func _move(delta):
	direction.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	
	if direction.y > 0 and swim == false and attack == false and !is_on_wall() and health_now > 0:
		if velocity.y < 0 :
			$spr.animation = "jump"
		elif velocity.y > 0:
			$spr.animation = "fall"
			
	if direction.y < 0 and swim == false and attack == false and !is_on_wall() and health_now > 0:
		if velocity.y == 0 and velocity.x == 0:
			$spr.animation = "crouch"
		elif velocity.y == 0 and velocity.x != 0:
			$spr.animation = "tackle"
		elif velocity.y > 0:
			$spr.animation = "fall"
		
	if direction.x != 0 and direction.y == 0 and swim == false and open_door == false and attack == false and !is_on_wall() and health_now > 0:
		if velocity.y == 0:
			$spr.animation = "walk"

		elif velocity.y > 0:
			$spr.animation = "fall"
		
	elif direction.x == 0 and direction.y == 0 and swim == false and open_door == false and attack == false and !is_on_wall() and health_now > 0:
		if velocity.y == 0:
			$spr.animation = "idle"
		elif velocity.y > 0:
			$spr.animation = "fall"

	if direction.x > 0:
		$spr.flip_h = false
		$attack_area.position.x = 18

	elif direction.x < 0:
		$spr.flip_h = true
		$attack_area.position.x = -18
	
	distance.x = speed*delta
	velocity.x = (direction.x*distance.x)/delta
	#if !is_on_wall():
	velocity.y += gravity*delta
	
	collision_info = move_and_slide(velocity,Vector2(0,-1))
	
	#var get_col = get_slide_collision(get_slide_count()-1)
	
	if velocity.y > 0:
		direction.y = 1
	
	if is_on_floor():
		velocity.y = 0
		direction.y = 0

		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_speed
			direction.y = 1
		if Input.is_action_pressed("ui_down") :
			direction.y = -1

			

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
			$spr.animation = "crouch"
			direction.y = -1

	#if is_on_wall():
	#	print("wall")
	#elif is_on_floor():
	#	print("floor")
	#else:
	#	print("xz")


		
		
func _attack():
	if Input.is_action_pressed("ui_attack1") and !is_on_wall() and health_now > 0: 
		attack = true
	else:
		attack = false
	if attack:
		$spr.animation = str(attack_name[rand_attack_name])

func _gui():
	$GUI/HPlabel.text = str(health, " / ", health_now )
	php = (health_now*100)/health
	$GUI/Healthbar.value = php
	$GUI/fps.text = str("FPS: ", Engine.get_frames_per_second())
	#if health_now < health:
	#	health_now += 1
		# Графический интерфейс игрока

func _on_spr_animation_finished():
	if $spr.animation == "attack2" or $spr.animation == "attack1" or $spr.animation == "attack3":
		rand_attack_name = randi()%3
	if $spr.animation == 'die':
		get_tree().change_scene("res://main/main.tscn")
	pass # Replace with function body.
	
func _death():
	if health_now <= 0:
			$spr.animation = 'die'
	pass

func _on_attack_area_body_entered(body):
	if body.get_class() == "KinematicBody2D" :
		body.health_now -= damage
		
		#body.anim = 'hurt'
	elif !body:
		$attack_area/col_Atack.disabled = true


func _on_spr_frame_changed():
	if $spr.animation == "attack2" or $spr.animation == "attack1" or $spr.animation == "attack3":
		if $spr.frame == 1:
			$attack_area/col_Atack.disabled = false
		elif $spr.frame == 4:
			$attack_area/col_Atack.disabled = true
	elif $spr.animation != "attack2" or $spr.animation != "attack1" or $spr.animation != "attack3":
		$attack_area/col_Atack.disabled = true
	pass # Replace with function body.
