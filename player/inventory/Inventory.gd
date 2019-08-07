extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var arrow_count_random
# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/ItemList.set_max_columns(10)
	$Panel/ItemList.set_fixed_icon_size(Vector2(16,16))
	$Panel/ItemList.set_icon_mode($Panel/ItemList.ICON_MODE_TOP)
	$Panel/ItemList.set_select_mode($Panel/ItemList.SELECT_SINGLE)
	$Panel/ItemList.set_same_column_width(true)
	$Panel/ItemList.set_allow_rmb_select(true)
	
	var arrow = ResourceLoader.load("res://items/arrow/assets/arrow.png")
	#var health_potion = ResourceLoader.load('res://items/Health Potion/Health Potion 1.png')
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	$Panel/ItemList.add_item("arrow",arrow)
	


	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	arrow_count_random = randi()%10+1
	pass


func _on_ItemList_item_selected(index):
	if $Panel/ItemList.get_item_text(index) == "arrow":
		print(arrow_count_random)
		print("arrow")
		
		$Panel/ItemList.remove_item(index)
	pass # Replace with function body.
