extends StaticBody2D

var open = false


func _process(delta):
	if open:
		$AnimationPlayer.play("opendoor")
		
	else:
		
		pass



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'opendoor':
		queue_free()
	pass # Replace with function body.
