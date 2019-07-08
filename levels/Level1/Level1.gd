extends Node2D

var tourch = false
var lever1 = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	if lever1:
		$exit_level.open_door = true
		
#	pass


func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		GLOBAL.Player_health = body.health_now
		get_tree().change_scene('res://levels/Level2/Level2.tscn')
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
			$Text_field/text.text = 'this dark... \n you need torch'
	pass # Replace with function body.



func _on_door_tree_exited():
	$Text_field/text.hide()
	$Text_field/text.text = ' '
	pass # Replace with function body.
