extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var button = false
export var end_kath = false
var text1 = tr("FIRST_CUT_SCENE_TEXT_1")
var text2 = tr("FIRST_CUT_SCENE_TEXT_2")
var text3 = tr("FIRST_CUT_SCENE_TEXT_3")
var text4 = tr("FIRST_CUT_SCENE_TEXT_4")
var text5 = tr("FIRST_CUT_SCENE_TEXT_5")
var text6 = tr("FIRST_CUT_SCENE_TEXT_6")
var text7 = tr("FIRST_CUT_SCENE_TEXT_7")
var text8 = tr("FIRST_CUT_SCENE_TEXT_8")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("ui_attack1") and button == false and visible == true:
		if $CanvasLayer/Label.text == text1:
			if $CanvasLayer/Label.percent_visible != 1:
				$text_full.stop()
				$CanvasLayer/Label.percent_visible = 1
			elif $CanvasLayer/Label.percent_visible == 1:
				$CanvasLayer/gobby.show()
				$CanvasLayer/Label.text = text2
			$change_text.start()
		elif $CanvasLayer/Label.text == "":
			if $CanvasLayer/Label.percent_visible != 1:
				$text_full.stop()
				$CanvasLayer/Label.percent_visible = 1
			elif $CanvasLayer/Label.percent_visible == 1:
				$start_cut.stop()
				$CanvasLayer/gobby.show()
				$CanvasLayer/Label.text = text1
			$change_text.start()
		elif $CanvasLayer/Label.text == text2:
			if $CanvasLayer/Label.percent_visible != 1:
				$text_full.stop()
				$CanvasLayer/Label.percent_visible = 1
			elif $CanvasLayer/Label.percent_visible == 1:
				$CanvasLayer/Label.text = text3
			$change_text.start()
		elif $CanvasLayer/Label.text == text3:
			if $CanvasLayer/Label.percent_visible != 1:
				$text_full.stop()
				$CanvasLayer/Label.percent_visible = 1
			elif $CanvasLayer/Label.percent_visible == 1:
				$CanvasLayer/Label.text = text4
			$change_text.start()
		elif $CanvasLayer/Label.text == text4:
			if $CanvasLayer/Label.percent_visible != 1:
				$text_full.stop()
				$CanvasLayer/Label.percent_visible = 1
			elif $CanvasLayer/Label.percent_visible == 1:
				$CanvasLayer/Label.text = text5
			$change_text.start()
			$Gobby.animation = "прыжок"
		elif $CanvasLayer/Label.text == text5:
			if $CanvasLayer/Label.percent_visible != 1:
				$text_full.stop()
				$CanvasLayer/Label.percent_visible = 1
			elif $CanvasLayer/Label.percent_visible == 1:
				$CanvasLayer/Label.text = text6
			$change_text.start()
		elif $CanvasLayer/Label.text == text6:
			if $CanvasLayer/Label.percent_visible != 1:
				$text_full.stop()
				$CanvasLayer/Label.percent_visible = 1
			elif $CanvasLayer/Label.percent_visible == 1:
				$Gobby.animation = "стойка"
				$CanvasLayer/Label.text = text7
			$change_text.start()
		elif $CanvasLayer/Label.text == text7:
			if $CanvasLayer/Label.percent_visible != 1:
				$text_full.stop()
				$CanvasLayer/Label.percent_visible = 1
			elif $CanvasLayer/Label.percent_visible == 1:
				$CanvasLayer/Label.text = text8
			$change_text.start()
		elif $CanvasLayer/Label.text == text8:
			$Gobby.flip_h = false
			$Gobby.animation = "хотьба"
			$CanvasLayer/Label.hide()
			$CanvasLayer/gobby.hide()
			$AnimationPlayer.play("exit")
	elif Input.is_action_just_pressed("ui_attack1") and button == true and visible == true:
		pass

	else : pass
	pass








func _on_start_cut_timeout():
	print("start")
	$CanvasLayer/Label.percent_visible = 0
	$text_full.play("full")
	$CanvasLayer/Label.text = text1
	$CanvasLayer/gobby.show()
	$change_text.start()
	pass # Replace with function body.


func _on_change_text_timeout():
	if $CanvasLayer/Label.text == text1:
		$CanvasLayer/Label.percent_visible = 0
		$text_full.play("full")
		$CanvasLayer/gobby.show()
		$change_text.start()
		$CanvasLayer/Label.text = text2
	elif $CanvasLayer/Label.text == text2:
		$CanvasLayer/Label.percent_visible = 0
		$text_full.play("full")
		$CanvasLayer/Label.text = text3
		$change_text.start()
	elif $CanvasLayer/Label.text == text3:
		$CanvasLayer/Label.percent_visible = 0
		$text_full.play("full")
		$CanvasLayer/Label.text = text4
		$change_text.start()
	elif $CanvasLayer/Label.text == text4:
		$CanvasLayer/Label.percent_visible = 0
		$text_full.play("full")
		$CanvasLayer/Label.text = text5
		$change_text.start()
		$Gobby.animation = "прыжок"
	elif $CanvasLayer/Label.text == text5:
		$CanvasLayer/Label.percent_visible = 0
		$text_full.play("full")
		$CanvasLayer/Label.text = text6
		$change_text.start()
	elif $CanvasLayer/Label.text == text6:
		$CanvasLayer/Label.percent_visible = 0
		$text_full.play("full")
		$Gobby.animation = "стойка"
		$CanvasLayer/Label.text = text7
		$change_text.start()
	elif $CanvasLayer/Label.text == text7:
		$CanvasLayer/Label.percent_visible = 0
		$text_full.play("full")
		$CanvasLayer/Label.text = text8
		$change_text.start()
	elif $CanvasLayer/Label.text == text8:
		$CanvasLayer/Label.percent_visible = 0
		$text_full.play("full")
		$Gobby.flip_h = false
		$Gobby.animation = "хотьба"
		$CanvasLayer/Label.hide()
		$CanvasLayer/gobby.hide()
		$AnimationPlayer.play("exit")
	pass # Replace with function body.


func _on_Button_focus_entered():
	button = true
	pass # Replace with function body.


func _on_Button_focus_exited():
	button = false
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	get_parent().get_parent().get_node("Player").cut_scene = false
	get_parent().get_parent().first_cut_scene = true
	queue_free()
	pass # Replace with function body.


func _on_Button_pressed():
	queue_free()
	pass # Replace with function body.
