extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var show_label = false
export var text_say = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$say_label.text = text_say
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$say_label.text = text_say
	if show_label:
		$say_label.show()
		$say_label/Timer.start()
		show_label = false
#	pass


func _on_Timer_timeout():
	hide()
	text_say = ""
	show_label= false
	pass # Replace with function body.
