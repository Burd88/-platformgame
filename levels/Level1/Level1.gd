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
		print("2")
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
	$Text_field/text.text = ' '
	$tourch_area.queue_free()
	pass # Replace with function body.
