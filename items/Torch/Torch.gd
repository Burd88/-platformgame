extends Node2D

var useable = true

#func _on_use_area_body_entered(body):
#	if body.name == 'Player':
#		body.torch = true
#		queue_free()
#	pass # Replace with function body.


func _on_tourch_area_area_entered(area):
	if area.name == "use":
		#say_label.show()
		get_parent().get_parent().get_node("Player").get_node("GUI/say_label").text = "Чертов калдун, а как же мой меч!!!"
		get_parent().get_parent().get_node("Player").get_node("GUI/say_label").show_label = true
		area.get_parent().torch = true
		queue_free()
	pass # Replace with function body.
