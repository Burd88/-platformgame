extends Node2D

#var tourch = false
var lever1 = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasModulate.show()
	$Text_field/text.show()
	$Chain/AnimatedSprite.stop()
	$Gear6.visible = false
	$decor/Gear2/Sprite/AnimationPlayer.playback_speed = -0.5
	$decor/Gear4/Sprite/AnimationPlayer.playback_speed = -0.5
	$Gear6/Gear6/Sprite/AnimationPlayer.playback_speed = -0.5
	$decor/Gear7/Gear7/Sprite/AnimationPlayer.stop()

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	start_mechanism()
	if Input.is_action_just_pressed("ui_cancel"):
		$pause_menu/Popup.show()
		get_tree().paused = true
		#$Player/spr.stop()
		modulate = Color(0.470588, 0.192157, 0.192157)
		$Text_field.layer = -1
		#$Player/GUI.layer = -1
		#$Player/inventary.layer = -1
	if lever1:
		$exit_level.open_door = true


		
#	pass
func start_mechanism():
	if $Gear6.visible == true:
		$Chain/AnimatedSprite.play("default")
		$Lift_level1/moveTween.start()
		$Lift_exit/moveTween.start()
	else :
		$Chain/AnimatedSprite.stop()

func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		body.position = Vector2(296,844)
	pass # Replace with function body.


func _on_tourch_area_body_entered(body):
	if body.name == 'Player':
		if body.torch == false:
			if translationt.language == 1:
				$Text_field/text.text = 'Тут очень темно.... и сыро... \n Тебе нужно взять факел'
			elif translationt.language == 2:
				$Text_field/text.text = 'this dark... \n you need torch'
		elif body.torch == true:
			$Text_field/text.text = ' '
	pass # Replace with function body.


func _on_tourch_area_body_exited(body):
	if body.name == 'Torch':
		$Text_field/text.text = ' '
	pass # Replace with function body.


func _on_Torch_tree_exited():
	$Text_field/text.hide()
	
	pass # Replace with function body.





func _on_door_text_area_body_entered(body):
	if body.name == 'Player':
		$Text_field/text.show()
		if translationt.language == 1:
			$Text_field/text.text = 'От этой стены дует прохладный ветерок... \n попробуй ее сдвинуть \n используй "E"'
		elif translationt.language == 2:
			$Text_field/text.text = 'From this wall blows cool breeze... \n try to move it \n use "E"'
	pass # Replace with function body.



func _on_door_tree_exited():
	$Text_field/text.hide()
	$Text_field/text.text = ' '  
	pass # Replace with function body.


func _on_Button_pressed():
	$Text_field/text.hide()
	pass # Replace with function body.



func _onlift_body_exited(body):
	if body.name == 'Player':
		$Text_field/text.hide()
	pass # Replace with function body.

## Недостоющий итем для механизма для ливтов ##
func _on_Gear7_area_entered(area):
	if area.name == 'use':
		var icon = ResourceLoader.load("res://items/gear/gear.png")
		var item_count = $Player/inventary/inventory/bag1.get_item_count()
		
		if item_count < 4:
			$Player/inventary/inventory/bag1.add_item("",icon)
			$Player/inventary/inventory/bag1.set_item_metadata(item_count,"Gear")
			$decor/Gear7.queue_free()
		else:
			print("Inventory is full")
		
	pass # Replace with function body.

## установка недостающей шестерни ##
func _on_Gear6_area_entered(area):
	if area.name == 'use':
		#print('fuck')
		for i in range(0, 4):
			if $Player/inventary/inventory/bag1.get_item_metadata(i) == "Gear":
				$Gear6.visible = true
				$Player/inventary/inventory/bag1.remove_item(i)
			else:
				$Text_field/text.show()
				if translationt.language == 1:
					$Text_field/text.text = 'Нужно найти деталь, чтоб механизм заработал'
				elif translationt.language == 2:
					$Text_field/text.text = 'need find item for this meshanism'








func _on_pause_Button_pressed():
	get_tree().paused = false
	$pause_menu/Popup.hide()
	$Player/spr.playing = true
	modulate = Color(1, 1, 1)
	$Text_field.layer = 1
	$Player/GUI.layer = 1
	$Player/inventary.layer = 1
	pass # Replace with function body.


func _on_exitgame_pause_menu_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_save_pressed():
	var save_game = File.new()
	save_game.open("res://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("save_group")
	print(save_nodes)
	for i in save_nodes:
		var node_data = i.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()
	pass # Replace with function body.


func _on_Button4_pressed():
	
	var save_game = File.new()
	if not save_game.file_exists("res://savegame.save"):
		
		return print("error")# Error! We don't have a save to load.

    # We need to revert the game state so we're not cloning objects
    # during loading. This will vary wildly depending on the needs of a
    # project, so take care with this step.
    # For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("save_group")
	for i in save_nodes:
		i.queue_free()
	
    # Load the file line by line and process that dictionary to restore
    # the object it represents.
	save_game.open("res://savegame.save", File.READ)
	while (!save_game.eof_reached()):
		
		var current_line = parse_json(save_game.get_line())
		
        # Firstly, we need to create the object and add it to the tree and set its position.
		
		var new_object = load(current_line["filename"]).instance()
		print(current_line["filename"])
		get_node(current_line["parent"]).add_child(new_object)
		
		new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
        # Now we set the remaining variables.
		
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, current_line[i])
	save_game.close()
	pass # Replace with function body.
	pass # Replace with function body.
