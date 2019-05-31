extends KinematicBody2D

var speed = 50
var jump_speed = 150
var gravity = 200

## жизни игрока
var health = 300
var health_now = health-35
var php = (health_now*100)/health
##----------------------- 

var distance = Vector2()
var velocity = Vector2()
var direction = Vector2(1,0)
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
	pass

func _move_enemy(delta):
	if is_on_wall():
		#print("wall")
		
		if direction.x == 1:
		 	direction.x = -1 
		elif direction.x == -1:
			direction.x = 1
	
	distance.x = speed*delta
	velocity.x = (direction.x*distance.x)/(delta+0.00001)
	#if !is_on_wall():
	velocity.y += gravity*delta
	
	move_and_slide(velocity,Vector2(0,-1))
	pass
	
func _gui():
	$HPlable.text = str(health, " / ", health_now )
	php = (health_now*100)/health
	$healthbar.value = php

func _damage():
	if health_now <= 0:
		GLOBAL.player_dead()
		queue_free()
	pass
		# Графический интерфейс игрока