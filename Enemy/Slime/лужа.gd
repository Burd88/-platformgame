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
	print($Timer.time_left)
	pass
func start(now_position):
	position = now_position 

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on__body_entered(body):
	if body.name == "Player":
		body.health_now -= 100
	pass # Replace with function body.
