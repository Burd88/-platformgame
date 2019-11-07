extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$inter/button/Start_game.text = tr("M_BT_NEW_GAME")
	$inter/button/Exit.text = tr("M_BT_EXIT")
	$inter/button/settings.text = tr("M_BT_SETTINGS")
	$inter/button/Continue.text = tr("M_BT_LOAD_GAME")
	$inter/button/controls.text = tr("CONTROLS_NAME_TEXT")
	$inter/Game_name.text = tr("GAME_NAME")

	$inter/version.text = tr("M_BT_VERSION") + " : " + str(ProjectSettings.get("application/config/version"))
	
#### save game chek text
	$inter/chack_save_game/ok.text = tr("M_BT_SGC_OK")
	$inter/chack_save_game/cancel.text = tr("M_BT_SGC_CANCEL")
	$inter/chack_save_game/Label.text = tr("M_BT_SGC_LABEL")
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		$inter/button/Continue.disabled = true
	elif save_game.file_exists("user://savegame.save"):
		$inter/button/Continue.disabled = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$music.volume_db = GLOBAL.music_value


	#if translationt.language == 1 :
#		$inter/button/Start_game.text = 'Начать игру'
	#	$inter/button/Continue.text = 'Продолжить'
	#	$inter/button/Exit.text = 'Выход'
	#elif translationt.language == 2 :
	#	$inter/button/Start_game.text = 'Start Game'
	#	$inter/button/Continue.text = 'Continue'
	#	$inter/button/Exit.text = 'Exit'
	#pass


func _on_Start_game_pressed():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		get_tree().change_scene("res://levels/Level1/Level1.tscn")
		GLOBAL.load_game = "new_game"
	
	elif save_game.file_exists("user://savegame.save"):
		$inter/chack_save_game.show()
		$inter/button.hide()
		pass
		




func _on_Exit_pressed():
	print("Quit the Game")
	get_tree().quit()
	pass # закрыть игру


func _on_Continue_pressed():
	GLOBAL.load_game = "loading_game"
	print("должно быть загружено сохранение")
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	save_game.open("user://savegame.save", File.READ)
	
	while save_game.eof_reached() == false:
		var try_current_line = parse_json(save_game.get_line())
		if try_current_line != null:
			if try_current_line.get("savelevel"):
				var current_line = try_current_line["savelevel"]
				get_tree().change_scene(current_line["level"])
				print("change scene : " ,current_line["level"])
        # Firstly, we need to create the object and add it to the tree and set its position.
			#var new_object = load(current_line["filename"]).instance()
		
			#get_node(current_line["parent"]).add_child(new_object)
			#new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
        # Now we set the remaining variables.
				for i in current_line.keys():
					if i == "level" or i == "name":
						continue
					get_parent().set(i, current_line[i])
			elif try_current_line == null:
				save_game.eof_reached() == true
	save_game.close()
	pass # Replace with function body.



func _on_ok_pressed():
	get_tree().change_scene("res://levels/Level1/Level1.tscn")
	var dir = Directory.new()
	dir.remove("user://savegame.save")
	GLOBAL.load_game = "new_game"
	pass # Replace with function body.
	


func _on_cancel_pressed():
	$inter/chack_save_game.hide()
	$inter/button.show()
	pass # Replace with function body.


func _on_settings_pressed():
	$inter/Options/Panel.show()
	$inter/button.hide()
#	$inter/Options/Button.show()
	pass # Replace with function body.




	pass # Replace with function body.


func _on_controls_pressed():
	$inter/Controls.show()
	$inter/button.hide()
	pass # Replace with function body.


func _on_controle_close_pressed():
	$inter/Controls.hide()
	$inter/button.show()
	pass # Replace with function body.


func _on_option_cancel_pressed():
	$inter/Options/Panel.hide()
	$inter/button.show()
	pass # Replace with function body.
