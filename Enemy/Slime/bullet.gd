extends Area2D
var speed = 200

onready var puddle = preload("res://Enemy/Slime/puddle.tscn")
var velocity = Vector2()

func start(pos, dir):
	position = pos
	rotation = dir
#	print(dir)
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta
	velocity.y += gravity*delta

func _on_bullet_body_entered(body):
	
	if body.name == 'Player':
		body.health_now -= 153
		queue_free()
	elif body.name == 'frontground':
		print("-_-")
		var now_position = position
		var b = puddle.instance()
		b.start(now_position)
		get_parent().add_child(b)
		queue_free()

		
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
