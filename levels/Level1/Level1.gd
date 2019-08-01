extends Node2D

var tourch = false
var lever1 = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasModulate.show()
	$Text_field/text.show()
	$Chain/AnimatedSprite.stop()
	$Gear6.visible = false
	$decor/Gear2/Sprite/AnimationPlayer.playback_speed = -0.5
	$decor/Gear4/Sprite/AnimationPlayer.playback_speed = -0.5
	$Gear6/Gear6/Sprite/AnimationPlayer.playback_speed = -0.5
	$Gear7/Gear7/Sprite/AnimationPlayer.stop()

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()
	start_mechanism()
	if lever1:
		$exit_level.open_door = true


		
#	pass
func start_mechanism():
	if $Gear6.visible == true:
	
		$Chain/AnimatedSprite.play("default")
		for i in range(0, $Text_field/ItemList.get_item_count()):
			if $Text_field/ItemList.get_item_text(i) == "Gear":
				$Text_field/ItemList.remove_item(i)

		$Lift_level1/moveTween.start()
		$Lift_exit/moveTween.start()
	else :
		$Chain/AnimatedSprite.stop()

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
			$Text_field/text.text = 'From this wall blows cool breeze... \n try to move it \n use "E"'
	pass # Replace with function body.



func _on_door_tree_exited():
	$Text_field/text.hide()
	$Text_field/text.text = ' '  
	pass # Replace with function body.


func _on_Button_pressed():
	$Text_field/text.hide()
	pass # Replace with function body.


func _on_lift_body_entered(body):
	if body.name == 'Player':
		$Text_field/text.show()
		if translationt.language == 1:
			$Text_field/text.text = 'Где-то слышно воду... \n надо сходить посмотреть'
		elif translationt.language == 2:
			$Text_field/text.text = 'Where is sound water... \n need see this'
	pass # Replace with function body.



func _onlift_body_exited(body):
	if body.name == 'Player':
		$Text_field/text.hide()
	pass # Replace with function body.


func _on_Gear7_area_entered(area):
	if area.name == 'use':
		var icon = ResourceLoader.load("res://items/gear/gear.png")
		$Text_field/ItemList.add_item("Gear",icon)
		$Gear7.queue_free()
	
	pass # Replace with function body.


func _on_Gear6_area_entered(area):
	if area.name == 'use':
		print('fuck')
		for i in range(0, $Text_field/ItemList.get_item_count()):
			if $Text_field/ItemList.get_item_text(i) == "Gear":
				$Gear6.visible = true
	
