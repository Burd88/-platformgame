extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var icon  = ResourceLoader.load("res://items/Health Potion/Health Potion 1.png")
var metadata = "Health_potion"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Health_potion_body_entered(body):
	if body.name == 'Player':
		body.health_potion += 1
		#if body.health_now > body.health:
		#	body.health_now = body.health
		queue_free()
	pass # Replace with function body.
