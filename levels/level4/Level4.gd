extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if GLOBAL.load_game == "new_game":
		pass
	elif GLOBAL.load_game == "loading_game":
		PauseMenu.preload_game()
	pass # Replace with function body.
	PauseMenu.ready_press = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func save_levels():
	var save_level = {
		"name" : name,
		"level" : filename
		}
	return save_level
