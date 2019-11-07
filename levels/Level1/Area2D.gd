extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target
# Called when the node enters the scene tree for the first time.
func _ready():
	$Torch/Light2D.enabled = false
	$Torch2/Light2D.enabled = false
	if get_parent().get_parent().end_cut_14 == true:
		queue_free()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_parent().end_cut_14 == true :
		$CollisionShape2D.disabled = true
	else: pass
	pass


func _on_Area2D_body_entered(body):
	if body.get("player_type") == true:
		$Torch/Light2D.enabled = true
		$Torch2/Light2D.enabled = true
		target = body
		$Door_gobby_exit.show()
		$Timer.start()
		body.get_node("Camera2D").current = false
		body.cut_scene = true
		get_parent().get_node("Boss_Gobby2").hide()
		
		
	pass # Replace with function body.


func _on_Timer_timeout():
	$Katboss13/Camera2D.current = true
	$Katboss13/CanvasLayer/Label.show()
	$Katboss13.show()
	$Katboss13/start_cut.start()
	pass # Replace with function body.
	pass # Replace with function body.


func _on_Cut_scene_boss_gobby_area_exited(area):
	if area.name == "cut_scene":
		$CollisionShape2D.set_deferred("disabled", true)
		if get_parent().get_parent().end_cut_14 == false:
			$Door_gobby_exit.door_close = 1
		else: pass
		
		if target != null:
			target.cut_scene = false
			
		
	pass # Replace with function body.
	pass # Replace with function body.
