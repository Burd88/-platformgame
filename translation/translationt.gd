extends Node
var language = 2 # 1 - ru, 2  - en
var tr_text
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if language == 1:
		tr_text = 'Тут очень темно.... и сыро... \n Тебе нужно взять факел'
	elif language == 2:
		tr_text = 'this dark... \n you need torch'
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
