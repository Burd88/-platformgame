extends KinematicBody2D

var speed = 50
var jump_speed = 150
var gravity = 200
var enemy_type = true
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
### sounds
onready var damage_hurt2_sound = preload("res://sounds/sound effect/Socapex - blub_hurt2.wav")

####


onready var bullet = preload("res://Enemy/Slime/bullet.tscn")
onready var big_heal_potion = preload("res://items/Items/health_potion/big_heal_potion.tscn")
onready var heal_potion = preload("res://items/Items/health_potion/heal_potion.tscn")
onready var lesser_heal_potion = preload("res://items/Items/health_potion/leser_heal_potion.tscn")
onready var major_heal_potion = preload("res://items/Items/health_potion/major_heal_potion.tscn")
onready var minor_heal_potion = preload("res://items/Items/health_potion/minor_heal_potion.tscn")
onready var arrow_item = preload("res://items/Items/Arrow.tscn")

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
		#print(target)
		aim()
	_gui()
	_move_enemy(delta)
	_death()
	_check_place()
	$sprite.animation = anim
	pass
func _damage(damage):
	health_now -= damage
	$damage_sound.stream = damage_hurt2_sound
	$damage_sound.play()
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
	
	
func _gui():# Графический интерфейс
	if health_now > 0 :
		$healthbar.show()
		#$HPlable.show()
	else:
		$healthbar.hide()
		#$HPlable.hide()
	$HPlable.text = str(health, " / ", health_now )
	php = (health_now*100)/health
	$healthbar.value = php

func _death():
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
		var result = space_state.intersect_ray(position, pos, [self])
		if result:
			#print(result.collider.name)
			hit_pos.append(result.position)
			if result.collider.name == "Player" and health_now > 0 and position.distance_to(target.position) > 40 :
				move_to_player = true
				anim = 'attack'
				direction = (target.position - position).normalized()
				if direction.x < 0 :
					$sprite.flip_h = false
					$attack_area.position.x = -30
					$check_attack.position.x = -30
					$check_place.position.x = -28
				elif direction.x > 0:
					$sprite.flip_h = true
					$attack_area.position.x = 30
					$check_attack.position.x = 30
					$check_place.position.x = 28
				move_to_player = true
				if can_shoot:
					shoot(pos)
				break
			elif result.collider.name == "Player"and health_now > 0 and position.distance_to(target.position) <= 40:
				pass
			elif result.collider.name == "frontground":
				pass
			else:
				move_to_player = false
				anim = "move"

#func _draw():
#	if target:
#		for hit in hit_pos:
#			draw_circle(((hit - position)*2).rotated(-rotation), 5, laser_color)
#			draw_line(Vector2(), ((hit - position)*2).rotated(-rotation), laser_color)
#	pass
		
func shoot(pos):
	var b = bullet.instance()
	var a = (pos - global_position).angle()
	b.start(position, a + rand_range(-0.05, 0.05),200)
	get_parent().add_child(b)
	can_shoot = false

func _on_AnimatedSprite_animation_finished():
	if $sprite.animation == 'die':
		queue_free()
		var item_rand = randi()%5
	#	print(item_rand)
		if item_rand == 0 :
			_drop_item()
			#print("бутылек")
	pass

func _drop_item():
	var item_drop = randi()%2
	if item_drop == 0:
		var item = lesser_heal_potion.instance()
		get_parent().add_child(item)
		item.position = position
	elif item_drop == 1:
		var item = minor_heal_potion.instance()
		get_parent().add_child(item)
		item.position = position
#	elif item_drop == 2:
#		var item = heal_potion.instance()
#		get_parent().add_child(item)
#		item.position = position
#	elif item_drop == 1:
#		var item = arrow_item.instance()
#		get_parent().add_child(item)
#		item.position = position

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
	if $attack_area.position.x == -30:
		$attack_area.position.x = 30
		$check_attack.position.x = 30
	else:
		$attack_area.position.x = -30
		$check_attack.position.x = -30



func _on_attack_area_body_entered(body):
	if body.name == 'Player' and health_now > 0:
		damage = randi()%20+10
		body._damage(damage)
#		body.health_now -= damage
		
		#print("attack  :"  , damage)
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
	if body.get("player_type"): # == 'Player':
		if target:
			return
		#print(body.name)
		target = body
	else :
		pass 

func _on_Visible_body_exited(body):
	if body == target:
		target = null
		move_to_player = false
		anim = "idle"
		#$attack_area/attack_col.disabled = false
	pass

func _on_check_attack_body_entered(body):
	if body.name == 'Player' and health_now > 0:
		speed = 0
		pass 
	pass # Replace with function body.


func _on_check_attack_body_exited(body):
	if body.name == 'Player' and health_now > 0:
		speed = 50
		pass 
	pass # Replace with function body.
