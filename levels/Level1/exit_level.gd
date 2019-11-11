extends Area2D

var open_door = false
var open = false


func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_parent().exit1level_open == true:
		$Sprite.animation = "full_open"
		open = true
#			$Sprite.playing = false
		$CollisionShape2D.disabled = false
	pass




func _on_Sprite_frame_changed():
	if $Sprite.animation == "open":
		if $Sprite.frame == 4:
			get_parent().get_parent().exit1level_open = true
			$Sprite.animation = "full_open"
#			$Sprite.playing = false
			$CollisionShape2D.disabled = false
	pass # Replace with function body.
