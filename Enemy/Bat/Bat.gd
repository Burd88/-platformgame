extends KinematicBody2D

var health = 300
var health_now = health
var php = (health_now*100)/health
export var move_to = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.play("fly")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_BatArea_body_entered(body):
	if body.name == 'Player':
		body.health_now -= 100
	pass # Replace with function body.
