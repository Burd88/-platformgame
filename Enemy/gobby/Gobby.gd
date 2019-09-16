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
var target
var damage
onready var big_heal_potion = preload("res://items/Items/health_potion/big_heal_potion.tscn")
onready var heal_potion = preload("res://items/Items/health_potion/heal_potion.tscn")
onready var lesser_heal_potion = preload("res://items/Items/health_potion/leser_heal_potion.tscn")
onready var major_heal_potion = preload("res://items/Items/health_potion/major_heal_potion.tscn")
onready var minor_heal_potion = preload("res://items/Items/health_potion/minor_heal_potion.tscn")
onready var arrow_item = preload("res://items/Items/Arrow.tscn")

var distance = Vector2()
var velocity = Vector2()
var direction = Vector2(-1,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	if target and health_now > 0:
		aim()
	_move_enemy(delta)
	_check_place()
	_die()
	_gui()
	pass
	
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

func aim():
	direction = (target.position - position).normalized()
	if direction.x < 0 :
		$spriteanim/attack.flip_h = false
		$spriteanim/idle.flip_h = false
		$spriteanim/move.flip_h = false
		$spriteanim/die.flip_h = false
		$spriteanim/jump.flip_h = false
		$attack_area.position.x = -12
		$damage.position.x = -15
		$check_place.position.x = -9
	elif direction.x > 0:
		$spriteanim/attack.flip_h = true
		$spriteanim/idle.flip_h = true
		$spriteanim/move.flip_h = true
		$spriteanim/die.flip_h = true
		$spriteanim/jump.flip_h = true
		$attack_area.position.x = 12
		$damage.position.x = 15
		$check_place.position.x = 9

func _drop_item():
	var item_drop = randi()%3
	if item_drop == 0:
		var item = lesser_heal_potion.instance()
		get_parent().add_child(item)
		item.position = position
	elif item_drop == 1:
		var item = minor_heal_potion.instance()
		get_parent().add_child(item)
		item.position = position
	elif item_drop == 2:
		var item = heal_potion.instance()
		get_parent().add_child(item)
		item.position = position
#	elif item_drop == 1:
#		var item = arrow_item.instance()
#		get_parent().add_child(item)
#		item.position = position


func _move_enemy(delta):
	if is_on_floor():
		velocity.y = 0
		direction.y = 0
	distance.x = speed
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
	#$HPlable.text = str(health, " / ", health_now )
	php = (health_now*100)/health
	$healthbar.value = php
	
func _die():
	if health_now <= 0:
		velocity = Vector2(0,0)
		direction = Vector2(0,0)
		gravity = 0
		$CollisionShape2D.disabled = true
		$spriteanim/die.show()
		$spriteanim/move.hide()
		$spriteanim/idle.hide()
		$spriteanim/attack.hide()
		$spriteanim/die/AnimationPlayer.play("die")
		
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
	if $spriteanim/attack.flip_h == false:
		$spriteanim/attack.flip_h = true
		$spriteanim/idle.flip_h = true
		$spriteanim/move.flip_h = true
		$spriteanim/die.flip_h = true
		$spriteanim/jump.flip_h = true
	else:
		$spriteanim/attack.flip_h = false
		$spriteanim/idle.flip_h = false
		$spriteanim/move.flip_h = false
		$spriteanim/die.flip_h = false
		$spriteanim/jump.flip_h = false
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
		$spriteanim/die.hide()
		$spriteanim/move.hide()
		$spriteanim/idle.hide()
		$spriteanim/attack.show()
		$spriteanim/jump.hide()
		$spriteanim/attack/AnimationPlayer.play("attack")
	pass # Replace with function body.


func _on_attack_area_body_exited(body):
	if body.get("player_type"):
		target = body
		speed = 50
		$spriteanim/die.hide()
		$spriteanim/move.show()
		$spriteanim/idle.hide()
		$spriteanim/attack.hide()
		$spriteanim/jump.hide()
		$spriteanim/attack/AnimationPlayer.stop()
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack" and health_now > 0:
		$damage/CollisionShape2D.disabled = false
		$spriteanim/attack/AnimationPlayer.play("attack")
	pass # Replace with function body.


func _on_damage_body_entered(body):
	if body.get("player_type"):
		body.health_now -= randi()%40+50
		$damage/CollisionShape2D.set_deferred("disabled" , true)
		#print("attack")
	pass # Replace with function body.


func _on_die_animation_finished(anim_name):
	if anim_name == "die":
		var item_rand = randi()%2
	#	print(item_rand)
		if item_rand == 0 :
			_drop_item()
		queue_free()
	pass # Replace with function body.





func _on_visible_body_entered(body):
	if body.get("player_type"):
		target = body
		$spriteanim/die.hide()
		$spriteanim/move.hide()
		$spriteanim/idle.hide()
		$spriteanim/attack.hide()
		$spriteanim/jump.show()
		$spriteanim/jump/AnimationPlayer.play("jump")
	pass # Replace with function body.


func _on_visible_body_exited(body):
	if body == target:
		target = null
		$spriteanim/die.hide()
		$spriteanim/move.show()
		$spriteanim/idle.hide()
		$spriteanim/attack.hide()
		$spriteanim/jump.hide()
		$spriteanim/jump/AnimationPlayer.stop()
	pass # Replace with function body.
