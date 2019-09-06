extends ItemList

var empty_slot = ResourceLoader.load("res://player/inventory/empty_slot.png")
var max_slots = 4
var arrow_count_random

# Called when the node enters the scene tree for the first time.
func _ready():
	set_max_columns(10)
	set_fixed_icon_size(Vector2(32,32))
	set_icon_mode(ICON_MODE_TOP)
	set_select_mode(SELECT_SINGLE)
	set_same_column_width(true)
	set_allow_rmb_select(true)
	add_item("",empty_slot)
	set_item_metadata(0,"Empty")


	
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var item_count = get_item_count()
	
	if item_count < max_slots:
		print(item_count)
		for i in range(4):
			if get_item_metadata(i) != null :
				pass
			else:
				add_item("",empty_slot)
				set_item_metadata(i,"Empty")
		#
	#var item_count = get_item_count()
	#if item_count < max_slots:
	#	add_item("",empty_slot)
	#	set_item_metadata(item_count,"Empty")
		
	if Input.is_action_just_released("check_inventory"):
		for i in range(4):
			print(get_item_metadata(i))
		pass


#func _on_ItemList_item_selected(index):

#	pass # Replace with function body.
