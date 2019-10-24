extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var damage_player = true

# Called when the node enters the scene tree for the first time.
func _ready():
	#position = Vector2(rand_range(80,430) , 1330)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(0,gravity)*delta
	pass
	pass
func start(pos,grav):
	position = pos
	gravity = grav

func _on_Stalactite_body_entered(body):
	if body.get("player_type") == true and damage_player == true:
		body._damage(100)
		queue_free()
	elif body.name == "frontground":
		damage_player = false
		$CollisionShape2D.set_deferred("disabled", true)
		$Sprite.animation = "defeat"
		gravity = 0
		
	pass # Replace with function body.


func _on_Sprite_animation_finished():
	if $Sprite.animation == "defeat":
		queue_free()
	pass # Replace with function body.
