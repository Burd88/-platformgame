extends Area2D
var speed = 200


var velocity = Vector2()

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta
	velocity.y += gravity*delta

func _on_bullet_body_entered(body):
	if body.name == 'Player':
		body.health_now -= 53
		queue_free()
	elif body.name == 'TileMap':
		queue_free()
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
