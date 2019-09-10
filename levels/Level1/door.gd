extends StaticBody2D

var open = false
var useable = true

func _process(delta):
	if open:
		$AnimationPlayer.play("opendoor")
		
	else:
		
		pass



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'opendoor':
		get_parent().get_parent().door_delete = true
		queue_free()
	pass # Replace with function body.


#func _on_door_text_area_area_entered(area):
#	if area.name == "use":
#		get_parent().get_parent().get_node("Player/E-key").hide()
#	pass # Replace with function body.


#func _on_door_text_area_body_exited(body):
#	if body.name == "Player":
#		get_parent().get_parent().get_node("Player/E-key").hide()
#	pass # Replace with function body.

