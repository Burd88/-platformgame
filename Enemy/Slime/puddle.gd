extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = 60
	print("лужа")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $ray1.is_colliding() :
		print($ray1.is_colliding())
		rotation_degrees = 90
		if $RayCast2D.is_colliding() == false:
			position.y += 10
		elif $RayCast2D2.is_colliding() == false:
			position.y -= 10
		$ray1.enabled = false
		$ray2.enabled = false
	elif $ray2.is_colliding() :
		rotation_degrees = 270
		if $RayCast2D.is_colliding() == false:
			position.y -= 10
		elif $RayCast2D2.is_colliding() == false:
			position.y += 10
		$ray1.enabled = false
		$ray2.enabled = false
	else:
		$ray1.enabled = false
		$ray2.enabled = false

	#print($Timer.time_left)
	pass

func start(now_position):
	position = now_position 

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on__body_entered(body):
	if body.name == "Player":
		body.health_now -= 100
		print("damage")
	pass # Replace with function body.


func _on_Timer2_timeout():
	$CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = false
	pass # Replace with function body.
