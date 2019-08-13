extends Node2D

const IDLE_DURATION = 1.0
export var move_to = Vector2.RIGHT*192
export var speed = 3.0


var follow = Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_tween()
	
func _init_tween():
	var duration = move_to.length() / float(speed * 16)
	$move_trap.interpolate_property(self, "follow" , Vector2.ZERO, move_to, duration ,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	$move_trap.interpolate_property(self, "follow" ,  move_to, Vector2.ZERO, duration ,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	$move_trap.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$trap.position = $trap.position.linear_interpolate(follow, 0.075)
	pass

func _on_kill_area_body_entered(body):
	if body.name == "Player":
		body.health_now = 0
		print("Player killing")
	else:
		print("no Player")
	pass # Replace with function body.
