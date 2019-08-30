extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
		pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
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
	get_tree().change_scene("res://levels/Level1/Level1.tscn")
	GLOBAL.load_game = "new_game"
	pass # начать новую игру


func _on_Exit_pressed():
	print("Quit the Game")
	get_tree().quit()
	pass # закрыть игру


func _on_Continue_pressed():
	GLOBAL.load_game = "loading_game"
	print("должно быть загружено сохранение")
	var save_game = File.new()
	if not save_game.file_exists("res://savelevel.save"):
		return # Error! We don't have a save to load.

	save_game.open("res://savelevel.save", File.READ)
	
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if current_line != null:
			
			get_tree().change_scene(current_line["level"])
			
        # Firstly, we need to create the object and add it to the tree and set its position.
			#var new_object = load(current_line["filename"]).instance()
		
			#get_node(current_line["parent"]).add_child(new_object)
			#new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
        # Now we set the remaining variables.
			#for i in current_line.keys():
			#	if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
			#		continue
			#	new_object.set(i, current_line[i])
		elif current_line == null:
			save_game.eof_reached() == true
	save_game.close()
	pass # Replace with function body.


func _on_ru_pressed():
	translationt.language = 1
	pass # Replace with function body.


func _on_en_pressed():
	translationt.language = 2
	pass # Replace with function body.
