extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = 60
	
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	
	if $ray1.is_colliding() == true:
		#print(1)
		rotation_degrees = 90
		#while $RayCast2D.is_colliding() == false:
		#	position.y +=10
		#while $RayCast2D2.is_colliding() == false:
		#	position.y -=10
		$ray1.enabled = false
		$ray2.enabled = false
	elif $ray2.is_colliding() == true :
		rotation_degrees = 270
		#print(2)
		#while $RayCast2D2.is_colliding() == false:
		#	position.y +=10
		#while $RayCast2D.is_colliding() == false:
		#	position.y -=10
		$ray1.enabled = false
		$ray2.enabled = false
	#else:
		
		#$ray1.enabled = false
		#$ray2.enabled = false
		
	#if rotation_degrees == 90 :
	#	if $RayCast2D.is_colliding() == false:
	#		position.y += 10
	#		$RayCast2D.enabled = false
	#	elif $RayCast2D2.is_colliding() == false:
	#		position.y -= 10
	#		$RayCast2D2.enabled = false
	#	else:
	#		pass
	#elif rotation_degrees == 270:
	#	if $RayCast2D.is_colliding() == false:
	#		position.y -= 10
	#		$RayCast2D.enabled = false
	#	elif $RayCast2D2.is_colliding() == false:
	#		position.y += 10
	#		$RayCast2D2.enabled = false
	#	else: pass
		#print(4)
		#$RayCast2D.enabled = false
	#elif rotation_degrees== 270 and $RayCast2D.is_colliding() == false:
		#position.y -= 10
		#print(5)
		#$RayCast2D2.enabled = false
	#else : 
		
	#	pass
		
	#if rotation_degrees== 90 and  $RayCast2D2.is_colliding() == false:
		#position.y -= 10
	#	print(7)
		#$RayCast2D.enabled = false
	#elif rotation_degrees== 270 and  $RayCast2D2.is_colliding() == false:
		#position.y += 10
	#	print(8)
		#$RayCast2D2.enabled = false
	#else : 
		
		pass
	#print($Timer.time_left)
	scale -= Vector2(0.001, 0.001)
	if scale == Vector2(0,0):
		#print("delete scale")
		queue_free()
	pass

func start(now_position):
	position = now_position 

func _on_Timer_timeout():
	queue_free()
	#print("delete timer")
	pass # Replace with function body.

func _on_Timer2_timeout():
	$CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = false
	pass # Replace with function body.

func _on_puddle_body_entered(body):
	if body.name == "Player":
		body.health_now -= 100
		print("damage")
	pass
