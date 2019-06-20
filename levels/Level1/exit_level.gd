extends Area2D

var open_door = false
var lever = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if open_door:
		$CollisionShape2D.disabled = false
		
	else:
		$CollisionShape2D.disabled = true
#	pass
