extends Node2D

var useable = true

#func _on_use_area_body_entered(body):
#	if body.name == 'Player':
#		body.torch = true
#		queue_free()
#	pass # Replace with function body.


func _on_tourch_area_area_entered(area):
	if area.name == "use":
		area.get_parent().get_node("$say_label").text = "Чертов Колдун, я же забыл свое оружие!!!"
		area.get_parent().get_node("$say_label").show_label = true
		area.get_parent().torch = true
		queue_free()
	pass # Replace with function body.
