extends KinematicBody2D

var speed = 50
var jump_speed = 150
var gravity = 200

## жизни игрока
var health = 300
var health_now = health
var php = (health_now*100)/health
##----------------------- 
var anim = 'move'

var damage

var distance = Vector2()
var velocity = Vector2()
var direction = Vector2(-1,0)

var move_to_player = false
var target
var hit_pos
var can_shoot = false
onready var bullet = preload("res://Enemy/Slime/bullet.tscn")
onready var health_potion = preload("res://items/Health Potion/Health_potion.tscn")

export (int) var detect_radius = 250
var shape_ext = Vector2(60,250)
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)

# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Visible/visible_col.shape = shape

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	if target:
		#print(direction.x)
		aim()
		#_attack_player()
		#print(position.distance_to(target.position))
		#print(global_position.angle_to(target.global_position))
		#if global_position.angle_to(target.global_position) < 1 and global_position.angle_to(target.global_position) > 0:
		#	pass#print("pravo")
		#	
		#elif global_position.angle_to(target.global_position) > -1 and global_position.angle_to(target.global_position) < 0:
		#	pass#print("levo")
	
	_gui()
	_move_enemy(delta)
	_damage()
	_check_place()
	#_attack_player()
	$sprite.animation = anim
	
	pass

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"health" : health ,
		"Health_now" : health_now,
		"php" : php,
		"name" : name,
	}

	return save_dict

func _move_enemy(delta):
	if is_on_floor():
		velocity.y = 0
		direction.y = 0
	distance.x = speed
	if $check_place.is_colliding() == false and move_to_player :
		velocity.x = 0
	else:
		velocity.x = (direction.x*distance.x)
	velocity.y += gravity*delta
	move_and_slide(velocity,Vector2(0,-1))
	pass
	
func _attack_player():

	pass
	pass
	
func _gui():# Графический интерфейс
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
		gravity = 0
		$CollisionShape2D.disabled = true
		$attack_area/attack_col.disabled = true
		$Visible/visible_col.disabled = true
		anim = 'die'
		
	pass
		
		
func aim():

		hit_pos = []
		var space_state = get_world_2d().direct_space_state
		var target_extents = target.get_node('CollisionShape2D').shape.extents# - Vector2(1 , 2)
		#print("target_extents : ", target_extents)
		var nw = target.position - target_extents
		var se = target.position + target_extents
		var ne = target.position + Vector2(target_extents.x, -target_extents.y)
		var sw = target.position + Vector2(-target_extents.x, target_extents.y)
		for pos in [target.position, nw, ne, se, sw]:
			var result = space_state.intersect_ray(position, pos, [self], collision_mask)
			if result:
				#print(result)
		
				hit_pos.append(result.position)
				#print(hit_pos.append(result.position))
				if result.collider.name == "Player" and health_now > 0 and position.distance_to(target.position) > 40 :
					move_to_player = true
					anim = 'attack'
					#print(position.distance_to(target.position))
					direction = (target.position - position).normalized()
					#print(direction)
					if direction.x < 0 :
					#if global_position.angle_to(target.global_position) < 1 and global_position.angle_to(target.global_position) > 0:
		#	pass#print("pravo")
						
						$sprite.flip_h = false
						$attack_area.position.x = 0
						$check_place.position.x = -28
					#elif global_position.angle_to(target.global_position) > -1 and global_position.angle_to(target.global_position) < 0:
					elif direction.x > 0:
						
						$sprite.flip_h = true
						$attack_area.position.x = 40
						$check_place.position.x = 28
					move_to_player = true
					
					if can_shoot:
						#print("distance attack")
						shoot(pos)
					break
				elif result.collider.name == "Player"and health_now > 0 and position.distance_to(target.position) <= 40:
					#print("milleattake")
					pass
				elif result.collider.name == "frontground":
					#print("no player")
					pass
				else:
					move_to_player = false
					anim = "move"
		
func _draw():
	#draw_circle(Vector2(), detect_radius, vis_color)
	#draw_rect(Rect2(position,$Visible/visible_col.shape.extents) , vis_color)
	if target:
		for hit in hit_pos:
			draw_circle(((hit - position)*2).rotated(-rotation), 5, laser_color)
			draw_line(Vector2(), ((hit - position)*2).rotated(-rotation), laser_color)
	pass
		
func shoot(pos):
	var b = bullet.instance()
	var a = (pos - global_position).angle()
	b.start(position, a + rand_range(-0.05, 0.05))
	get_parent().add_child(b)
	can_shoot = false

func _health_potion():
	var b = health_potion.instance()
	get_parent().add_child(b)
	b.position = position

func _check_place():
	if $check_place.is_colliding() == false :
		if !move_to_player and is_on_floor():
			_change_position()
	if is_on_wall() and !move_to_player :
		_change_position()

func _change_position():
	direction.x =direction.x*(-1)
	$check_place.position.x = $check_place.position.x*(-1)
	if $sprite.flip_h == false:
		$sprite.flip_h = true
	else:
		$sprite.flip_h = false
		pass
	if $attack_area.position.x == 0:
		$attack_area.position.x = 40
	else:
		$attack_area.position.x = 0

func _on_AnimatedSprite_animation_finished():
	if $sprite.animation == 'die':
		queue_free()
		var item_rand = randi()%2
	#	print(item_rand)
		if item_rand == 0 :
			_health_potion()
			print("бутылек")
	pass

func _on_attack_area_body_entered(body):
	if body.name == 'Player' and health_now > 0:
		damage = randi()%40+30
		body.health_now -= damage
		print("attack")
		anim = 'attack'
	pass

func _on_sprite_frame_changed():
	if $sprite.animation == 'attack' and health_now > 0:
		if $sprite.frame == 1:
			$attack_area/attack_col.disabled = true
		elif $sprite.frame == 3:
			$attack_area/attack_col.disabled = false
	if $sprite.animation == 'move':
		pass
	elif $sprite.animation == 'attack':
		if $sprite.frame == 2:
			can_shoot = true
		pass

func _on_Visible_body_entered(body):

	if body.name == 'Player':
		if target:
			return
		target = body
		print(body.name)
		#	target = body
		#	move_to_player = true
	else :
		#print(body.name)
		pass 

func _on_Visible_body_exited(body):
	if body == target:
		target = null
		move_to_player = false
		anim = "idle"
		#$attack_area/attack_col.disabled = false
	pass

func _on_attack_area_body_exited(body):
	if body.name == 'Player' and health_now > 0:
		#$attack_area/attack_col.disabled = false
		pass 