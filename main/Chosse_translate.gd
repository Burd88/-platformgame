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


func _on_russian_pressed():
	TranslationServer.set_locale("ru")
	get_tree().change_scene("res://main/main.tscn")
	pass # Replace with function body.


func _on_english_pressed():
	TranslationServer.set_locale("en")
	get_tree().change_scene("res://main/main.tscn")
	pass # Replace with function body.
