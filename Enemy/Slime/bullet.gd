extends Area2D
var speed = 200
var type_bullet = true
onready var puddle = preload("res://Enemy/Slime/puddle.tscn")
var velocity = Vector2()
var bullet_trap = false
func start(pos, dir,spd):
	position = pos
	rotation = dir
	#print(dir)
	velocity = Vector2(spd, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta
	velocity.y += gravity*delta

func _on_bullet_body_entered(body):
	
	if body.get("player_type") == true:
		body._damage(randi()%35+1)
		queue_free()
	elif body.name == 'frontground':
		#print("-_-")
		var now_position = position
		var b = puddle.instance()
		b.start(now_position)
		#b.call_deferred("start" , now_position)
		get_parent().call_deferred("add_child",b)
		queue_free()

		
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
