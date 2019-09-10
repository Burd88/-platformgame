extends Area2D
var use_lever = false
var useable = true

func _process(delta):
	if get_parent().get_parent().lever1:
		$Sprite.flip_h = true
	elif !get_parent().get_parent().lever1:
		if use_lever:
			$CollisionShape2D.disabled = true
			$Sprite.flip_h = true
			get_parent().get_parent().lever1 = true

func _on_lever_area_entered(area):
	if area.name == 'use':
		use_lever = true
#		get_parent().get_parent().get_node("Player/E-key").hide()
	pass

#func _on_lever_body_exited(body):
#	if body.name == 'Player':
#		get_parent().get_parent().get_node("Player/E-key").hide()
#	pass
#
#func _on_lever_body_entered(body):
#	if body.name == 'Player':
#		get_parent().get_parent().get_node("Player/E-key").show()
#	pass
