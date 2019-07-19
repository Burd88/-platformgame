extends Node2D

const IDLE_DURATION = 1.0
export var move_to = Vector2.UP 
export var speed = 3.0

var follow = Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var duration = move_to.length() / speed
	$moveTween.interpolate_property(self, "follow" , Vector2.ZERO, move_to, duration ,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	$moveTween.interpolate_property(self, "follow" ,  move_to, Vector2.ZERO, duration ,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration * IDLE_DURATION * 2)
	#$moveTween.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#position = position.linear_interpolate(follow, 0.075)
	pass
