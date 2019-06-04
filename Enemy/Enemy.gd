extends KinematicBody2D

var speed = 50
var jump_speed = 150
var gravity = 200

## жизни игрока
var health = 300
var health_now = health-35
var php = (health_now*100)/health
##----------------------- 
var anim = 'move'

var distance = Vector2()
var velocity = Vector2()
var direction = Vector2(-1,0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_gui()
	_move_enemy(delta)
	_damage()
	_check_place()
	$sprite.animation = anim
	pass

func _move_enemy(delta):
	if is_on_floor():
		velocity.y = 0
		direction.y = 0
	
	
	#if is_on_wall():
		#print("wall")
		
	#	if direction.x == 1:
	#	 	direction.x = -1 
	#	elif direction.x == -1:
		#	direction.x = 1
	
	distance.x = speed*delta
	velocity.x = (direction.x*distance.x)/(delta+0.00001)
	#if !is_on_wall():
	velocity.y += gravity*delta
	
	move_and_slide(velocity,Vector2(0,-1))
	pass
	
func _gui():
	if health_now > 0 :
		$healthbar.show()
		$HPlable.show()
	else:
		$healthbar.hide()
		$HPlable.hide()
	$HPlable.text = str(health, " / ", health_now )
	php = (health_now*100)/health
	$healthbar.value = php

func _damage():
	if health_now <= 0:
		anim = 'die'
	pass
		# Графический интерфейс игрока
func _check_place():
	if is_on_floor():
		#print($RayCast2D.get_collider())
		if $RayCast2D.is_colliding() == false:
			direction.x =direction.x*(-1)
			$RayCast2D.position.x = $RayCast2D.position.x*(-1)
			if $sprite.flip_h == false:
				$sprite.flip_h = true
			else:
				$sprite.flip_h = false
			pass
			if $attack_area.position.x == 0:
				$attack_area.position.x = 60
			else:
				$attack_area.position.x = 0
	else:
		pass			

func _on_AnimatedSprite_animation_finished():
	if $sprite.animation == 'die':
		queue_free()
	
	pass # Replace with function body.


func _on_attack_area_body_entered(body):
	if body.name == 'Player':
		body.health_now -= 50
		anim = 'attack'
	
	print(body.get_class())
	pass # Replace with function body.


func _on_sprite_frame_changed():
	if $sprite.animation == 'attack':
		if $sprite.frame == 1:
			$attack_area/attack_col.disabled = false
		elif $sprite.frame == 4:
			$attack_area/attack_col.disabled = true
	pass # Replace with function body.
