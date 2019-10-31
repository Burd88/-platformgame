extends Area2D
var use_lever = false
var useable = true

func _ready():
	$audio.volume_db = GLOBAL.sound_value
func _process(delta):
	pass

func _on_lever_area_entered(area):
	if area.name == 'use':
		$audio.play()
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
		get_parent().get_parent().lever1 = true
		get_parent().get_node("exit_level/Sprite").animation = "open"
		get_parent().get_node("exit_level/AudioStreamPlayer2D").volume_db = GLOBAL.sound_value
		get_parent().get_node("exit_level/AudioStreamPlayer2D").play()
	pass



func _on_Area2D_body_entered(body):
	if body.get("player_type") == true:
		body.move_camera(Vector2(500,170))
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.
