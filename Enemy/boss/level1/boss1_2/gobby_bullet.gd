extends Area2D
var speed = 150
var type_bullet = true
var velocity = Vector2()
var bullet_trap = false
func start(pos,flip):
	position = pos
	$AnimatedSprite.flip_h = flip
	#print(dir)
	if flip == true:
		velocity = Vector2(-speed, 0)
	else:
		velocity = Vector2(+speed, 0)

func _physics_process(delta):
	position += velocity * delta
	#velocity.y += gravity*delta

func _on_bullet_body_entered(body):
	

		
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_gobby_bullet_body_entered(body):
	if body.get("player_type") == true:
		body._damage(randi()%15+20)
		queue_free()
	
	elif body.name == "frontground":
		queue_free()

	pass # Replace with function body.
