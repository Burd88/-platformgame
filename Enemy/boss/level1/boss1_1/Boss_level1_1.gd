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
var damage
var attack_now = false
var shot_var = true
var distance = Vector2()
var velocity = Vector2()
var direction = Vector2(-1,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
		get_parent().add_child(b)
		b.position = position + Vector2(0 , 30)
		b.get_node("sprite").speed_scale = 0.7
		b.health = 120
		b.damage = 30
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
		get_parent().get_parent().get_parent().boss1_1_kill = true
		queue_free()
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.get("player_type"):
		direction = (body.position-position).normalized()
		pass
	pass # Replace with function body.
