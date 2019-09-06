extends Node2D

#var tourch = false
var lever1 = false
var mexanism = false
var door_delete = false
var torch_delete = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#print(GLOBAL.load_game)
	if GLOBAL.load_game == "new_game":
		pass
	elif GLOBAL.load_game == "loading_game":
		$pause_menu.preload_game()
	$CanvasModulate.show()
	#$Text_field/text.show()
	$Chain/AnimatedSprite.stop()
	$Gear6.visible = false
	$decor/Gear2/Sprite/AnimationPlayer.playback_speed = -0.5
	$decor/Gear4/Sprite/AnimationPlayer.playback_speed = -0.5
	$Gear6/Gear6/Sprite/AnimationPlayer.playback_speed = -0.5
	$Gear7/Gear7/Sprite/AnimationPlayer.stop()
	if torch_delete == true:
		$Torch.queue_free()
	if door_delete == true:
		$door.queue_free()
		
	for i in get_child_count():
		if get_child(i).filename:
			print(get_child(i).name)


	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	start_mechanism()
	if Input.is_action_just_pressed("ui_cancel"):
		$pause_menu/Popup.show()
		get_tree().paused = true

		#$Player/spr.stop()
		#modulate = Color(0.470588, 0.192157, 0.192157)
		#$Text_field.layer = -1
		#$Player/GUI.layer = -1
		#$Player/inventary.layer = -1
	if lever1:
		$exit_level.open_door = true
func save_levels():
	var save_level = {
		"level" : filename,
		"mexanism" : mexanism,
		"lever1" : lever1,
		"door_delete" : door_delete,
		"torch_delete" : torch_delete,
		}
	return save_level
#	pass
func start_mechanism():
	if mexanism == true:
		$Chain/AnimatedSprite.play("default")
		$Lift_level1/moveTween.start()
		$Lift_exit/moveTween.start()
		$Gear6.visible = true
	else :pass
		#$Chain/AnimatedSprite.stop()

func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		body.position = Vector2(296,844)
	pass # Replace with function body.


#func _on_tourch_area_body_entered(body):
#	if body.name == 'Player':
#		if body.torch == false:
#			if translationt.language == 1:
#				$Text_field/text.text = 'Тут очень темно.... и сыро... \n Тебе нужно взять факел'
#			elif translationt.language == 2:
#				$Text_field/text.text = 'this dark... \n you need torch'
#		elif body.torch == true:
#			$Text_field/text.text = ' '
#	pass # Replace with function body.


#func _on_tourch_area_body_exited(body):
#	if body.name == 'Torch':
##		$Text_field/text.text = ' '
#	pass # Replace with function body.


#func _on_Torch_tree_exited():
#	$Text_field/text.hide()
#	pass # Replace with function body.

func _on_door_text_area_body_entered(body):
	if body.name == "Player":
		body.get_node("E-key").show()
	else:pass




#func _on_door_tree_exited():
#	$Text_field/text.hide()
#	$Text_field/text.text = ' '  
#	pass # Replace with function body.


#func _on_Button_pressed():
#	$Text_field/text.hide()
#	pass # Replace with function body.



#func _onlift_body_exited(body):
#	if body.name == 'Player':
##		$Text_field/text.hide()
#	pass # Replace with function body.

## Недостоющий итем для механизма для ливтов ##
func _on_Gear7_area_entered(area):
	if area.name == 'use':
		$"Player/E-key".hide()
		var icon = ResourceLoader.load("res://items/gear/gear.png")
		var item_count = $Player/inventary/inventory/bag1.get_item_count()
		if item_count < 4:
			$Player/inventary/inventory/bag1.add_item("",icon)
			$Player/inventary/inventory/bag1.set_item_metadata(item_count,"Gear")
			$Gear7.queue_free()
		else:
			print("Inventory is full")
		
	pass # Replace with function body.

## установка недостающей шестерни ##
func _on_Gear6_area_entered(area):
	if area.name == 'use':
		
		for i in range(0, 4):
			if $Player/inventary/inventory/bag1.get_item_metadata(i) == "Gear":
				$Gear6.visible = true
				$Player/inventary/inventory/bag1.remove_item(i)
				mexanism = true
				$"Player/E-key".hide()



func _on_Torch_tree_exited():
	torch_delete = true
	pass # Replace with function body.


