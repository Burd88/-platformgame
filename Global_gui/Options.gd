extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pressed_sound = false
var music_value = 0
var sound_value = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/Name.text = tr("OPTION_NAME_LABEL")
	$Panel/Music.text = tr("OPTION_MUSIC_LABEL")
	$Panel/Sound.text = tr("OPTION_SOUND_ALL_LABEL")
	
	$Panel/Sounds.text = tr("OPTION_SOUND_FX_LABEL")
	$Panel/Fullwiscreen.text = tr("OPTION_FULLSCREEN_LABEL")
	$Panel/cancel.text = tr("OPTION_CANCEL_BUTTON")
	$Panel/music_slide.value = GLOBAL.music_value
	$Panel/sound_slide.value = GLOBAL.sound_value
	if OS.window_fullscreen == true:
		$Panel/Fullscreen_check.pressed = true
	elif OS.window_fullscreen == false:
		$Panel/Fullscreen_check.pressed = false
	pass # Replace with function body.
	if pressed_sound == true:
		$Panel/Soundall.pressed = true
	elif pressed_sound == false:
		$Panel/Soundall.pressed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GLOBAL.sound_off == true:
		$Panel/music_slide.editable = false
		$Panel/sound_slide.editable = false
		$Panel/Soundall.pressed = true
		GLOBAL.music_value = -80
		GLOBAL.sound_value = -80
		$Panel/music_slide.value = GLOBAL.music_value_off
		$Panel/sound_slide.value = GLOBAL.sound_value_off
	elif GLOBAL.sound_off == false:
		$Panel/Soundall.pressed = false
		$Panel/music_slide.editable = true
		$Panel/sound_slide.editable = true
	pass





func _on_Fullscreen_check_toggled(button_pressed):
	if button_pressed:
		OS.window_fullscreen = true
	else: 
		OS.window_fullscreen = false
	pass # Replace with function body.


func _on_music_slide_value_changed(value):
	GLOBAL.music_value = value
	pass # Replace with function body.


func _on_sound_slide_value_changed(value):
	GLOBAL.sound_value = value
	pass # Replace with function body.


func _on_Soundall_toggled(button_pressed):
	if button_pressed:
		GLOBAL.sound_off = true
		GLOBAL.music_value_off = $Panel/music_slide.value
		GLOBAL.sound_value_off = $Panel/sound_slide.value
		GLOBAL.music_value = -80
		GLOBAL.sound_value = -80
		$Panel/music_slide.editable = false
		$Panel/sound_slide.editable = false
	else: 
		GLOBAL.sound_off = false
		GLOBAL.music_value = $Panel/music_slide.value
		GLOBAL.sound_value = $Panel/sound_slide.value
		$Panel/music_slide.editable = true
		$Panel/sound_slide.editable = true
		
	pass # Replace with function body.



func _on_cancel_pressed():
	$Panel.visible = false
	if get_parent().get("name") == "pause_menu":
		get_parent().set("pause_visble",true)
	pass # Replace with function body.
