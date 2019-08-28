extends Area2D

var speed = 250 
var velocity = Vector2()

#var direction = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func start(pos,dir):
	position = pos
	rotation_degrees = dir
	if dir == 0 :
		velocity =Vector2(speed , 0)
	elif dir == 180 :
		velocity =Vector2(-speed , 0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity*delta
	velocity.y += gravity*delta
	pass


func _on_arrow_body_entered(body):
	
	if body.name == "Slime":
		body.health_now -=100
		queue_free()
	elif body.name != "Slime":
		for i in range(0, 10) :
			if body.name == str("Slime",+i) or body.name == "Slime":
				body.health_now -=100
				queue_free()
			else:
				queue_free()
	
	pass # Replace with function body.
