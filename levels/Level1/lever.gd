extends StaticBody2D
var use_lever = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if use_lever:
		$Sprite.flip_h = true
		$"..".lever1 = true
		print('1')
		
#	pass
