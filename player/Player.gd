extends KinematicBody2D

var speed = 150
var jump_speed = 150
var gravity = 200

var health = 100


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

func _physics_process(delta):
	_move(delta)
	_attack()

func _move(delta):
	direction.x = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
	
	if direction.y > 0 and swim == false and attack == false and !is_on_wall():
		if velocity.y < 0 :
			$spr.animation = "jump"
		elif velocity.y > 0:
			$spr.animation = "fall"
			
	if direction.y < 0 and swim == false and attack == false and !is_on_wall():
		if velocity.y == 0 and velocity.x == 0:
			$spr.animation = "crouch"
		elif velocity.y == 0 and velocity.x != 0:
			$spr.animation = "tackle"
		elif velocity.y > 0:
			$spr.animation = "fall"
		
	if direction.x != 0 and direction.y == 0 and swim == false and open_door == false and attack == false and !is_on_wall():
		if velocity.y == 0:
			$spr.animation = "walk"

		elif velocity.y > 0:
			$spr.animation = "fall"
		
	elif direction.x == 0 and direction.y == 0 and swim == false and open_door == false and attack == false and !is_on_wall():
		if velocity.y == 0:
	
			$spr.animation = "idle"
			
		elif velocity.y > 0:
			$spr.animation = "fall"

	if direction.x > 0:
		$spr.flip_h = false
	#	$colis_down.position.x = 4
	#	$colis_up.position.x = 4
		#$check_cell.position.x = 4
		#$colis_hang.position.x = 10
		#$colis_hang.position.y = -12
		#$colis_hang.rotation_degrees = 270
	elif direction.x < 0:
		$spr.flip_h = true
	#	$colis_down.position.x = -4
		#$colis_up.position.x = -4
		#$check_cell.position.x = -4
		#$colis_hang.position.x = -10
		#$colis_hang.position.y = -12
		#$colis_hang.rotation_degrees = 90
		
	#if direction.y == -1 :#and check_cell:
	#	$colis_up.disabled = true
	#	$check_cell.enabled = true
		#$check_cell.show()
	#elif direction.y == 1 :#and !check_cell:
	#	$colis_up.disabled = false 
	#	$check_cell.enabled = false
		#$check_cell.hide()
	#else : 
	#	$colis_up.disabled = false 
		#$check_cell.enabled = false
		#$check_cell.hide()
		
	#if $check_cell.is_colliding():
		#check_cell = true
		#print($check_cell.get_collider())
		#print($check_cell.get_collision_normal()) 
	#else:
		#check_cell = false
	
	distance.x = speed*delta
	velocity.x = (direction.x*distance.x)/delta
	if !is_on_wall():
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

			

			
	if is_on_wall()  and !is_on_floor() and direction.y == 1:
		velocity.y = 0
		wall = true
		$spr.animation = "hang1"
		
		
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


		
		
func _attack():
	if Input.is_action_pressed("ui_attack1") and !is_on_wall(): 
		attack = true
	else:
		attack = false
	if attack:
		$spr.animation = "attack1"


		

func _on_spr_animation_finished():
	if $spr.animation == "attack1":
		print("attack")
	pass # Replace with function body.
