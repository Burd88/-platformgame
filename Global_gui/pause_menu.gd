extends CanvasLayer
var pause_menu = false
func _physics_process(delta):
	$music.volume_db = GLOBAL.music_value

func _on_pause_Button_pressed():
	get_parent().get_tree().paused = false
	pause_menu = false
	$music.visible = false
	$Popup.hide()
	
	#get_parent().modulate = Color(1, 1, 1)
	#get_parent().get_node("Player/GUI").layer = 1
	#get_parent().get_node("Player/inventary").layer = 1
	#get_parent().get_node("Player/spr").playing = true
	pass # Replace with function body.


func _on_exitgame_pause_menu_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_save_pressed():
	_save_game_data()
	
func _save_game_data():
	#Global_Player.save_data()
	print("Auto save")
	var save_game = File.new()
	save_game.open("res://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("save")
	var save_data = {"savedata" : {}}
	for i in save_nodes:
		print(i)
		var node_data = i.call("save")
		save_data["savedata"] = node_data
		save_game.store_line(to_json(save_data))
	var save_levels = {"savelevel" : {}}
	var save_level = get_tree().get_nodes_in_group("save_levels")
	for i in save_level:
		var level_data = i.call("save_levels")
		save_levels["savelevel"] = level_data	
	save_game.store_line(to_json(save_levels))
	#print(Global_Player.inventory)
	save_game.store_line(to_json({"inventory" : Global_Player.inventory}))
	save_game.close()
#	var save_levels = File.new()
	#save_levels.open("res://savelevel.save", File.WRITE)
	#var save_level = get_tree().get_nodes_in_group("save_levels")
#	for i in save_level:
	#	var level_data = i.call("save_levels")
	#	save_levels.store_line(to_json(level_data))
#	save_levels.close()
	#pass


func _on_Button4_pressed():
	preload_game()

func preload_game():
	var save_game = File.new()
	if not save_game.file_exists("res://savegame.save"):
		return print("error")
	save_game.open("res://savegame.save", File.READ)
	var save_nodes = get_tree().get_nodes_in_group("save")
	for i in save_nodes:
		i.queue_free()
	while save_game.eof_reached() == false:
		var try_current_line = parse_json(save_game.get_line())
		if try_current_line != null:
			if try_current_line.get("savelevel"):
				var current_line = try_current_line["savelevel"]
				print("Load : ", current_line["name"])
				for i in current_line.keys():
					if i == "level" or i == "name":
						continue
					get_parent().set(i, current_line[i])
			if try_current_line.get("inventory"):
				var current_line = try_current_line["inventory"]
				Global_Player.load_inventory = current_line
				Global_Player.load_data()
				print(Global_Player.load_inventory)
		elif try_current_line == null:
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
		var try_current_line = parse_json(save_game.get_line())
		if try_current_line != null:
			if try_current_line.get("savedata"):
				var current_line = try_current_line["savedata"]
				print("Load : ", current_line["name"])
				var new_object = load(current_line['filename']).instance()
				get_parent().get_node(current_line["parent"]).add_child(new_object)
				new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
				for i in current_line.keys():
					if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
						continue
					new_object.set(i, current_line[i])
			
		elif try_current_line == null:
			save_game.eof_reached() == true
			$loading/Timer.start()
		
	save_game.close()
	#Global_Player.load_data()
	#get_parent().get_node("Player/inventary/inventory/bag1").load_items()
	

func _on_loading_animation_finished(anim_name):
	load_game()
	pass


func _on_Timer_timeout():
	#print("timeout")
	$loading.hide()
	$Popup.hide()
	get_parent().get_tree().paused = false
	#get_parent().get_node("Player/inventary/inventory/bag1").load_items()
	#get_parent().modulate = Color(1, 1, 1)
	#$Text_field.layer = 1
	#get_parent().get_node("Player/GUI").layer = 1
	#get_parent().get_node("Player/inventary").layer = 1
	#get_parent().get_node("Player/spr").playing = true
	#$loading.hide()
	pass


func _on_Button5_pressed():
	$Options/Panel.show()
	$Options/Button.show()
	$Popup.hide()
	pass # Replace with function body.


func _on_Button_pressed():
	$Options/Panel.hide()
	$Options/Button.hide()
	$Popup.show()
	pass # Replace with function body.




func _on_music_visibility_changed():
	if $music.visible == true:
		$music.play()
	elif $music.visible == false:
		$music.stop()
	pass # Replace with function body.
