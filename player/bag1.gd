extends ItemList

var empty_slot = ResourceLoader.load("res://player/inventory/empty_slot.png")
var max_slots = 4
var arrow_count_random
var inventory 

var activeItemSlot:int = -1
var dropItemSlot:int = -1

onready var isDraggingItem:bool = false
onready var mouseButtonReleased:bool = true
var draggedItemSlot:int = -1
onready var initial_mousePos:Vector2 = Vector2()
onready var cursor_insideItemList:bool = false
var full__inventory = false
var isAwaitingSplit:bool = false
var splitItemSlot:int = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	set_max_columns(10)
	set_fixed_icon_size(Vector2(32,32))
	set_icon_mode(ICON_MODE_TOP)
	set_select_mode(SELECT_SINGLE)
	set_same_column_width(true)
	set_allow_rmb_select(true)
	Global_Player.load_data()
	load_items()
	set_process(false)
	set_process_input(true)
	
func _process(delta) -> void:
	if (isDraggingItem):
		$Sprite_DraggedItem.global_position = get_viewport().get_mouse_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var item_count = get_item_count()
#
#	if item_count < max_slots:
#		print(item_count)
#		for i in range(4):
#			if get_item_metadata(i) != null :
#				pass
#			else:
#				add_item("",empty_slot)
#				set_item_metadata(i,"Empty")
#		#
#	#var item_count = get_item_count()
#	#if item_count < max_slots:
#	#	add_item("",empty_slot)
#	#	set_item_metadata(item_count,"Empty")
#
#	if Input.is_action_just_released("check_inventory"):
#
#		var dict:Dictionary = {"inventory":{}}
#		#for i in range(4):
#
#		#	dict["inventory"][i] = { "i" : i, "metadata" : get_item_metadata(i),}
#		#inventory = dict["inventory"]
#		print(inventory)
#		pass

#func load_inventory():
#	var dict:Dictionary = {"inventory":{}}
#	for i in range(4):
#
#		dict["inventory"][i] = { "i" : i, "metadata" : get_item_metadata(i),}
#	inventory = dict["inventory"]
#	print(inventory)
#	return inventory
func _input(event) -> void:
#	if (!isDraggingItem):
#		if event.is_action_pressed("key_shift"):
#			isAwaitingSplit = true
#		if event.is_action_released("key_shift"):
#			isAwaitingSplit = false

	if (event is InputEventMouseButton ):
		if (!isAwaitingSplit):
			if (event.is_action_pressed("mouse_leftbtn")):
				mouseButtonReleased = false
				initial_mousePos = get_viewport().get_mouse_position()
				
			if (event.is_action_released("mouse_leftbtn")):
				move_merge_item()
				end_drag_item()
				
#		else:
#			if (event.is_action_pressed("mouse_rightbtn")):
#				if (activeItemSlot >= 0):
#					begin_split_item()
	
	if (event is InputEventMouseMotion ):
		if (cursor_insideItemList):
			
			activeItemSlot = get_item_at_position(get_local_mouse_position(),true)
			if (activeItemSlot >= 0):
				select(activeItemSlot, true)
				if (isDraggingItem or mouseButtonReleased):
					
					return
				if (!is_item_selectable(activeItemSlot)):
					
					end_drag_item()
				if (initial_mousePos.distance_to(get_viewport().get_mouse_position()) > 0.0):
					
					begin_drag_item(activeItemSlot)
		else:
			activeItemSlot = -1

	
func load_items():
	clear()
	for slot in range(0, Global_Player.inventory_maxSlots):
		add_item("", null, false)
		update_slot(slot)


func update_slot(slot:int) -> void:
	if (slot < 0):
		full__inventory = true
		return
		
	full__inventory = false
	#print(Global_Player.inventory)
	var inventoryItem:Dictionary = Global_Player.inventory[str(slot)]
	var itemMetaData = Global_ItemDatabase.get_item(str(inventoryItem["id"])).duplicate()
	var icon = ResourceLoader.load(itemMetaData["icon"])
	var amount = int(inventoryItem["amount"])

	itemMetaData["amount"] = amount
	if (!itemMetaData["stackable"]):
		amount = " "
	set_item_text(slot, String(amount))
	set_item_icon(slot, icon)
	set_item_selectable(slot, int(inventoryItem["id"]) > 0)
	set_item_metadata(slot, itemMetaData)
	set_item_tooltip(slot, itemMetaData["name"])
	set_item_tooltip_enabled(slot, int(inventoryItem["id"]) > 0)
#func _on_ItemList_item_selected(index):
func begin_drag_item(index:int) -> void:
	if (isDraggingItem):
		return
	if (index < 0):
		return

	set_process(true)
	$Sprite_DraggedItem.texture = get_item_icon(index)
	$Sprite_DraggedItem.show()

	set_item_text(index, " ")
	set_item_icon(index, ResourceLoader.load(Global_ItemDatabase.get_item("0")["icon"]))

	draggedItemSlot = index
	isDraggingItem = true
	mouseButtonReleased = false
	$Sprite_DraggedItem.global_translate(get_viewport().get_mouse_position())

#	pass # Replace with function body.
func end_drag_item() -> void:
	set_process(false)
	draggedItemSlot = -1
	$Sprite_DraggedItem.hide()
	mouseButtonReleased = true
	isDraggingItem = false
	activeItemSlot = -1
	
	
func move_merge_item() -> void:
	if (draggedItemSlot < 0):
		
		return
	if (activeItemSlot < 0):
		
		update_slot(draggedItemSlot)
		return

	if (activeItemSlot == draggedItemSlot):
		
		update_slot(draggedItemSlot)
	else:
		if (get_item_metadata(activeItemSlot)["id"] == get_item_metadata(draggedItemSlot)["id"]):
			
			var itemData =get_item_metadata(activeItemSlot)
			if (int(itemData["stack_limit"]) >= 2):
				Global_Player.inventory_mergeItem(draggedItemSlot, activeItemSlot)
				update_slot(draggedItemSlot)
				update_slot(activeItemSlot)
				return
			else:
				update_slot(draggedItemSlot)
				return
		else:
			
			Global_Player.inventory_moveItem(draggedItemSlot, activeItemSlot)
			update_slot(draggedItemSlot)
			update_slot(activeItemSlot)


		
func _on_bag1_mouse_entered():
	cursor_insideItemList = true;
	pass # Replace with function body.


func _on_bag1_mouse_exited():
	cursor_insideItemList = false;
	pass # Replace with function body.
