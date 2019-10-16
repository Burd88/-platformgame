extends Node2D

#var tourch = false
var lever1 = false
var mexanism = false
var door_delete = false
var torch_delete = false
var boss1_1_kill = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#print(GLOBAL.load_game)
	$music.play()
	if GLOBAL.load_game == "new_game":
		#$pause_menu._on_save_pressed()
		#print("save new game")
		pass
	elif GLOBAL.load_game == "loading_game":
		$pause_menu.preload_game()
	$CanvasModulate.show()
	#$Text_field/text.show()
	$decor/Chain/AnimatedSprite.stop()
	$use_item/Gear6.visible = false
	$decor/Gear2/Sprite/AnimationPlayer.playback_speed = -0.5
	$decor/Gear4/Sprite/AnimationPlayer.playback_speed = -0.5
	$use_item/Gear6/Gear6/Sprite/AnimationPlayer.playback_speed = -0.5
#	$use_item/Gear7/Gear7/Sprite/AnimationPlayer.stop()
	if torch_delete == true:
		$use_item/Torch.queue_free()
	if door_delete == true:
		$use_item/door.queue_free()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$music.volume_db = GLOBAL.music_value
	update()
	start_mechanism()
	if Input.is_action_just_pressed("ui_cancel"):
		$pause_menu/Popup.show()
		$pause_menu.pause_menu = true
		$pause_menu/music.visible = true
		get_tree().paused = true

	
		
		#$Player/spr.stop()
		#modulate = Color(0.470588, 0.192157, 0.192157)
		#$Text_field.layer = -1
		#$Player/GUI.layer = -1
		#$Player/inventary.layer = -1
	if lever1:
		$use_item/exit_level.open_door = true
func save_levels():
	var save_level = {
		"name" : name,
		"level" : filename,
		"mexanism" : mexanism,
		"lever1" : lever1,
		"door_delete" : door_delete,
		"torch_delete" : torch_delete,
		"boss1_1_kill" : boss1_1_kill,
		}
	return save_level
#	pass
func start_mechanism():
	if mexanism == true:
		$decor/Chain/AnimatedSprite.play("default")
		$decor/Lift_level1/moveTween.start()
		$decor/Lift_exit/moveTween.start()
		$use_item/Gear6.visible = true
		$use_item/Gear6/CollisionShape2D.disabled = true
	else :pass
		#$Chain/AnimatedSprite.stop()

func _on_Area2D_body_entered(body):
	if body.get("player_type"):
		body.position = Vector2(296,844)
	pass # Replace with function body.




func _on_Gear6_area_entered(area):
	if area.name == 'use':
		var yup = false

		for i in range(0,Global_Player.inventory_maxSlots):
			if $Player/inventary/inventory/bag1.get_item_metadata(i) == "Gear":
				$use_item/Gear6.visible = true
				Global_Player.inventory_removeItem(i)
				$Player/inventary/inventory/bag1.update_slot(i)
				mexanism = true
				yup = true
				$"Player/E-key".hide()
		if yup:
			$"Player/GUI/say_label".text = "Механизм заработал"
			$"Player/GUI/say_label".show_label = true
			
		else: 
			$"Player/GUI/say_label".text = "Похоже сюда нужна какая-то деталь"
			$"Player/GUI/say_label".show_label = true









