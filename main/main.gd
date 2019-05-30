extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
		pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_game_pressed():
	get_tree().change_scene("res://game.tscn")
	pass # начать новую игру


func _on_Exit_pressed():
	print("Quit the Game")
	get_tree().quit()
	pass # закрыть игру


func _on_Continue_pressed():
	print("должно быть загружено сохранение")
	pass # Replace with function body.
