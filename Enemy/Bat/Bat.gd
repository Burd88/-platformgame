extends KinematicBody2D

var health = 300
var health_now = health
var php = (health_now*100)/health
export var move_to = 100
var velocity = Vector2(-50,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite/AnimationPlayer.play("fly")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if is_on_wall():
		print("Wall bat")
		velocity.x = velocity.x*(-1)
		$Sprite.flip_h = true
	move_and_slide(velocity,Vector2(0,-1))
	pass


func _on_BatArea_body_entered(body):
	if body.name == 'Player':
		body.health_now -= 100
	pass # Replace with function body.
