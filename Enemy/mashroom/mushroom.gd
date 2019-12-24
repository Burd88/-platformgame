extends KinematicBody2D

var speed = 30
var jump_speed = 150
var gravity = 200
var enemy_type = true
## жизни игрока
export var health = 300
var health_now = health
var php = (health_now*100)/health
##----------------------- 
var anim = 'move'
var target
var damage
### sounds
onready var damage_hurt2_sound = preload("res://sounds/sound effect/Socapex - blub_hurt2.wav")
####
onready var big_heal_potion = preload("res://items/Items/health_potion/big_heal_potion.tscn")
onready var heal_potion = preload("res://items/Items/health_potion/heal_potion.tscn")
onready var lesser_heal_potion = preload("res://items/Items/health_potion/leser_heal_potion.tscn")
onready var major_heal_potion = preload("res://items/Items/health_potion/major_heal_potion.tscn")
onready var minor_heal_potion = preload("res://items/Items/health_potion/minor_heal_potion.tscn")
onready var arrow_item = preload("res://items/Items/Arrow.tscn")
onready var exp_point = preload("res://items/exp_point/Exp_point.tscn")
###движение
export var distance_max = 100
var visible_pl = false
var idle = true
var idle_timer = false
var spawn_position = Vector2()
var spawn_position_x
var spawn_position_y
var distance = Vector2()
var velocity = Vector2()
var direction = Vector2(-1,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_position = Vector2(position.x , position.y)

	$spr.animation = "хотьба"
	pass # Replace with function body.
func _settings():
	$music.volume_db = GLOBAL.music_value
	$attack_sound.volume_db = GLOBAL.sound_value
	$move_sound.volume_db = GLOBAL.sound_value
	$damage_sound.volume_db = GLOBAL.sound_value
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GLOBAL.load_game == "loading_game":
		spawn_position = Vector2(spawn_position_x , spawn_position_y)
	_settings()
	update()
	if target and health_now > 0:
		aim()
	if health_now > 0:
		_move_enemy(delta)
		_check_place()
	else:pass
	_die()
	_gui()
	pass
	
func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"spawn_position_x" : spawn_position.x,
		"spawn_position_y" : spawn_position.y,
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"health" : health ,
		"health_now" : health_now,
		"php" : php,
		"name" : name,
		"distance_max" : distance_max,
	}
	return save_dict

func _damage(damage):
	health_now -= damage
	$damage_sound.stream = damage_hurt2_sound
	$damage_sound.play()


func aim():
	direction = (target.position - position).normalized()
	if direction.x < 0 :
		$spr.flip_h = false
		$attack_area.position.x = -12
		$damage.position.x = -15
		$check_place.position.x = -9
	elif direction.x > 0:
		$spr.flip_h = true
		$attack_area.position.x = 12
		$damage.position.x = 15
		$check_place.position.x = 9

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


func _move_enemy(delta):
	if is_on_floor():
		velocity.y = 0
		direction.y = 0
	#print($spriteanim/idle/idletimer.time_left)
	#print(position.distance_to(spawn_position))
	if position.distance_to(spawn_position) < distance_max and visible_pl == false:
		distance.x = speed
		idle_timer = false
		idle = true
		
	elif position.distance_to(spawn_position) >= distance_max and visible_pl == false and idle_timer == false:
		
		if idle :
			idle = false
			$idletimer.start()
		distance.x = 0
		$spr.animation = "стойка"
	elif visible_pl == false and idle_timer == true:
		$spr.animation = "хотьба"
	elif visible_pl == true:
		distance.x = speed
		velocity.x = (direction.x*distance.x)
		velocity.y += gravity*delta
	else: print("move to spawn")
	#distance.x = -speed
	velocity.x = (direction.x*distance.x)
	velocity.y += gravity*delta
	move_and_slide(velocity,Vector2(0,-1))
	pass
func _on_idletimer_timeout():
	idle_timer = true
	_change_position()
	distance.x = speed
	pass # Replace with function body.


func flame_show():
	$flame.show()
	$flame/flame_area/CollisionShape2D.set_deferred("disabled", false)
	$flame/flame_damage.start()

func _on_flame_area_body_entered(body):
	if body.get("enemy_type"):
		print(body.name)
		if body.get_node("flame").visible == false:
			body.flame_show()
	elif body.get("player_type"):
		body._damage(30)
	pass # Replace with function body.

func _on_flame_damage_timeout():
	_damage(20)
	pass # Replace with function body.


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
	
func _die():
	if health_now <= 0:

		speed = 0
		velocity = Vector2(0,0)
		direction = Vector2(0,0)
		gravity = 0
		$damage/CollisionShape2D.disabled = true
		$attack_area/CollisionShape2D.disabled = true
		$visible/CollisionShape2D.disabled = true
		$check_place
		$CollisionShape2D.disabled = true
		$spr.animation = "смерть"

		###нужна анимация смерти
		
	pass
func _check_place():
	if $check_place.is_colliding() == false :
		if is_on_floor():
			_change_position()
	if is_on_wall():
		_change_position()
	
func _change_position():
	direction.x =direction.x*(-1)
	$check_place.position.x = $check_place.position.x*(-1)
	if $spr.flip_h == false:
		$spr.flip_h = true
	else:
		$spr.flip_h = false
		pass
	if $attack_area.position.x == -12:
		$attack_area.position.x = 12
		$damage.position.x = 15
	else:
		$attack_area.position.x  = -12
		$damage.position.x = -15
			
			

func _on_attack_area_body_entered(body):
	if body.get("player_type"):
		speed = 0
		$spr.animation = "атака"
	pass # Replace with function body.


func _on_attack_area_body_exited(body):
	if body.get("player_type"):
		target = body
		speed = 50
		$spr.animation = "хотьба"
	pass # Replace with function body.

func _on_spr_animation_finished():
	if $spr.animation == "смерть":
		var item_rand = randi()%5
		for i in randi()%3+2:
			var item = exp_point.instance()
			get_parent().add_child(item)
			item.position_start = position + Vector2(rand_range(-70,70),rand_range(-30,-70))
			item.position = position
	#	print(item_rand)
		if item_rand == 0 :
			_drop_item()
		queue_free()
	pass # Replace with function body.


#func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == "attack" and health_now > 0:
#		$damage/CollisionShape2D.disabled = false
#		$spriteanim/attack/AnimationPlayer.play("attack")
#	pass # Replace with function body.


func _on_damage_body_entered(body):
	if body.get("player_type"):
		body._damage(damage)

		#print("attack")
	pass # Replace with function body.


#func _on_die_animation_finished(anim_name):
#	if anim_name == "die":
#		var item_rand = randi()%5
#	#	print(item_rand)
#		if item_rand == 0 :
#			_drop_item()
#		queue_free()
#	pass # Replace with function body.





func _on_visible_body_entered(body):
	if body.get("player_type"):
		visible_pl = true
		target = body
		$spr.animation = "хотьба"
	pass # Replace with function body.


func _on_visible_body_exited(body):
	if body == target:
		visible_pl = false
		target = null
		$spr.animation = "хотьба"
	pass # Replace with function body.







func _on_spr_frame_changed():
	if $spr.animation == "атака":
		if $spr.frame == 3:
			damage = randi()%20+5
			#print(damage)
			$damage/CollisionShape2D.disabled = false
		elif $spr.frame == 7:
			$damage/CollisionShape2D.disabled = true
	pass # Replace with function body.
