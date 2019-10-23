extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(0,gravity)*delta
	pass
	pass


func _on_Stalactite_body_entered(body):
	if body.get("player_type") == true:
		body._damage(100)
	elif body.name == "frontground":
		$Sprite.animation = "defeat"
		gravity = 0
	pass # Replace with function body.


func _on_Sprite_animation_finished():
	if $Sprite.animation == "defeat":
		queue_free()
	pass # Replace with function body.
