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

var move_to_player = false
var target
var hit_pos
var can_shoot = false
onready var bullet = preload("res://Enemy/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	if target:
		aim()
		_attack_player()
	_gui()
	_move_enemy(delta)
	_damage()
	_check_place()
	_attack_player()
	$sprite.animation = anim
	pass

func _move_enemy(delta):
	if is_on_floor():
		velocity.y = 0
		direction.y = 0
	
	
	
	
	distance.x = speed*delta
	velocity.x = (direction.x*distance.x)/(delta+0.00001)
	#if !is_on_wall():
	velocity.y += gravity*delta
	
	move_and_slide(velocity,Vector2(0,-1))
	pass
	
func _attack_player():

	pass
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
		velocity = Vector2(0,0)
		direction = Vector2(0,0)
		$CollisionShape2D.disabled = true
		$attack_area/attack_col.disabled = true
		$Visible/visible_col.disabled = true
		anim = 'die'
	pass
		# Графический интерфейс игрока
		
func aim():

	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
	var nw = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, ne, se, sw]:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			hit_pos.append(result.position)
			if result.collider.name == "Player" and health_now > 0 and global_position.distance_to(target.global_position) > 70 and global_position.distance_to(target.global_position) < 90:
				anim = 'attack'
				#print((target.position - position).angle())
				print(direction.x)
				if can_shoot:
					shoot(pos)
				break
			
			elif position.distance_to(target.position) < 70 and position.distance_to(target.position) > 20:
				direction = (target.position - position).normalized()
				if direction.x < 0 :
					$sprite.flip_h = false
					$attack_area.position.x = 0
					$check_place.position.x = -28
				elif direction.x > 0:
					$sprite.flip_h = true
					$attack_area.position.x = 60
					$check_place.position.x = 28
				move_to_player = true
			elif global_position.distance_to(target.global_position) > 90 :
				anim = 'move'
				move_to_player = false
			elif global_position.distance_to(target.global_position) <= 20 :
				anim = 'attack'
				direction = Vector2(0,0)
				move_to_player = false
		
func shoot(pos):
	var b = bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.30, 0.30))
	get_parent().add_child(b)
	can_shoot = false


func _check_place():
	if $check_place.is_colliding() == false and !move_to_player and is_on_floor():
		_change_position()
	elif $check_place.is_colliding() == false and move_to_player and is_on_floor() :
		velocity.y = -jump_speed
	if is_on_wall() and !move_to_player :
		_change_position()
	elif is_on_wall() and move_to_player:
		velocity.y = -jump_speed
		
func _change_position():
	direction.x =direction.x*(-1)
	$check_place.position.x = $check_place.position.x*(-1)
	if $sprite.flip_h == false:
		$sprite.flip_h = true
	else:
		$sprite.flip_h = false
		pass
	if $attack_area.position.x == 0:
		$attack_area.position.x = 60
	else:
		$attack_area.position.x = 0

func _on_AnimatedSprite_animation_finished():
	if $sprite.animation == 'die':
		queue_free()
		
	if $sprite.animation == 'attack'  and health_now > 0:
		can_shoot = true
	
	pass # Replace with function body.


func _on_attack_area_body_entered(body):
	if body.name == 'Player' and health_now > 0:
		body.health_now -= 50
		anim = 'attack'
	pass # Replace with function body.


func _on_sprite_frame_changed():
	if $sprite.animation == 'attack' and health_now > 0:
		if $sprite.frame == 1:
			$attack_area/attack_col.disabled = true
		elif $sprite.frame == 4:
			$attack_area/attack_col.disabled = false
	pass # Replace with function body.





func _on_Visible_body_entered(body):
	if body.name == 'Player':
		target = body
		move_to_player = true
	pass # Replace with function body.


func _on_Visible_body_exited(body):
	if body.name == 'Player':
		target = null
		move_to_player = false
		pass
	pass # Replace with function body.



