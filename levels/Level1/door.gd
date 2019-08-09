extends StaticBody2D

var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if open:
		$AnimationPlayer.play("opendoor")
		
	else:
		
		pass
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'opendoor':
#		print('open')
		queue_free()
	pass # Replace with function body.
