extends Node2D

func _on_use_area_body_entered(body):
	if body.name == 'Player':
		body.torch = true
		
		queue_free()
	pass # Replace with function body.
