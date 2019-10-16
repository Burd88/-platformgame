extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var music_value = 0
var sound_value = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/music_slide.value = GLOBAL.music_value
	$Panel/sound_slide.value = GLOBAL.sound_value
	if OS.window_fullscreen == true:
		$Panel/Fullscreen_check.pressed = true
	elif OS.window_fullscreen == false:
		$Panel/Fullscreen_check.pressed = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
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
