extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Torch/Light2D.enabled = false
	$Torch2/Light2D.enabled = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
		
	pass


func _on_Area2D_body_entered(body):
	if body.get("player_type") == true:
		$Torch/Light2D.enabled = true
		$Torch2/Light2D.enabled = true
	pass # Replace with function body.
