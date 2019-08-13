extends ItemList

var arrow_count_random
# Called when the node enters the scene tree for the first time.
func _ready():
	set_max_columns(10)
	set_fixed_icon_size(Vector2(16,16))
	set_icon_mode(ICON_MODE_TOP)
	set_select_mode(SELECT_SINGLE)
	set_same_column_width(true)
	set_allow_rmb_select(true)
	
	var arrow = ResourceLoader.load("res://items/arrow/assets/arrow.png")
	#var health_potion = ResourceLoader.load('res://items/Health Potion/Health Potion 1.png')
	add_item("arrow",arrow)
	
	


	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	arrow_count_random = randi()%10+1
	pass


func _on_ItemList_item_selected(index):

	pass # Replace with function body.
