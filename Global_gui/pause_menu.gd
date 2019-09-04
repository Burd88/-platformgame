extends CanvasLayer
func _on_pause_Button_pressed():
	get_parent().get_tree().paused = false
	$Popup.hide()
	
	get_parent().modulate = Color(1, 1, 1)
	#$Player/GUI.layer = 1
	#$Player/inventary.layer = 1
	#$Player/spr.playing = true
	pass # Replace with function body.


func _on_exitgame_pause_menu_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_save_pressed():
	var save_game = File.new()
	save_game.open("res://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("save")
	for i in save_nodes:
		var node_data = i.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()
	var save_levels = File.new()
	save_levels.open("res://savelevel.save", File.WRITE)
	var save_level = get_tree().get_nodes_in_group("save_levels")
	for i in save_level:
		var level_data = i.call("save_levels")
		save_levels.store_line(to_json(level_data))
	save_levels.close()
	pass


func _on_Button4_pressed():
	preload_game()

func preload_game():
	var save_game = File.new()
	if not save_game.file_exists("res://savelevel.save"):
		return print("error")
	save_game.open("res://savelevel.save", File.READ)
	var save_nodes = get_tree().get_nodes_in_group("save")
	for i in save_nodes:
		i.queue_free()
	while save_game.eof_reached() == false:
		var current_line = parse_json(save_game.get_line())
		if current_line != null:
			for i in current_line.keys():
				if i == "level":
					continue
				get_parent().set(i, current_line[i])
		elif current_line == null:
			save_game.eof_reached() == true
	save_game.close()
	$loading.show()
	$loading/AnimationPlayer.play("loading")
	$Popup.hide()
	pass 
	
func load_game():
	var save_game = File.new()
	
	if not save_game.file_exists("res://savegame.save"):
		return print("error")
	save_game.open("res://savegame.save", File.READ)
	while save_game.eof_reached() == false:
		var current_line = parse_json(save_game.get_line())
		if current_line != null:
			print("Load : ", current_line["name"])
			var new_object = load(current_line['filename']).instance()
			get_parent().get_node(current_line["parent"]).add_child(new_object)
			new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
			for i in current_line.keys():
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
					continue
				new_object.set(i, current_line[i])
		elif current_line == null:
			save_game.eof_reached() == true
			$loading/Timer.start()
	save_game.close()
	

func _on_loading_animation_finished(anim_name):
	load_game()
	pass


func _on_Timer_timeout():
	#print("timeout")
	$loading.hide()
	$Popup.hide()
	get_parent().get_tree().paused = false
	#get_parent().modulate = Color(1, 1, 1)
	#$Text_field.layer = 1
	#$Player/GUI.layer = 1
	#$Player/inventary.layer = 1
	#$Player/spr.playing = true
	#$loading.hide()
	pass
