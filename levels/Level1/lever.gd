extends Area2D
var use_lever = false

func _process(delta):
	if $"..".lever1:
		$Sprite.flip_h = true
	elif !$"..".lever1:
		if use_lever:
			$Sprite.flip_h = true
			$"..".lever1 = true

func _on_lever_area_entered(area):
	if area.name == 'use':
		use_lever = true
		get_parent().get_node("Player/E-key").hide()
	pass

func _on_lever_body_exited(body):
	if body.name == 'Player':
		get_parent().get_node("Player/E-key").hide()
	pass

func _on_lever_body_entered(body):
	if body.name == 'Player':
		get_parent().get_node("Player/E-key").show()
	pass
