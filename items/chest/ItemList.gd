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

var isAwaitingSplit:bool = false
var splitItemSlot:int = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	set_max_columns(4)
	set_fixed_icon_size(Vector2(32,32))
	set_icon_mode(ICON_MODE_TOP)
	set_select_mode(SELECT_SINGLE)
	set_same_column_width(true)
	set_allow_rmb_select(true)
	set_process(false)
	set_process_input(true)
	
	
	var dict:Dictionary = {"inventory":{}}
	for slot in range (0, 4):
		var id_item = randi()%9+1
	
		dict["inventory"][str(slot)] = {"id": str(id_item), "amount": 1}
	#Global_DataParser.write_data(url_PlayerData, dict)
		inventory = dict["inventory"]
		
	load_items()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _input(event) -> void:
#	if (!isDraggingItem):
#		if event.is_action_pressed("key_shift"):
#			isAwaitingSplit = true
#		if event.is_action_released("key_shift"):
#			isAwaitingSplit = false

	if (event is InputEventMouseButton):
		if (!isAwaitingSplit):
			if (event.is_action_pressed("mouse_leftbtn")):
				mouseButtonReleased = false
				initial_mousePos = get_viewport().get_mouse_position()
			if (event.is_action_released("mouse_leftbtn")):
				pass
#		else:
#			if (event.is_action_pressed("mouse_rightbtn")):
#				if (activeItemSlot >= 0):
#					begin_split_item()
	if (event is InputEventMouseMotion):
		if (cursor_insideItemList):
			
			activeItemSlot = get_item_at_position(get_local_mouse_position(),true)
			if (activeItemSlot >= 0):
				select(activeItemSlot, true)
				if (isDraggingItem or mouseButtonReleased):
					
					return
				if (!is_item_selectable(activeItemSlot)):
					
					pass
				if (initial_mousePos.distance_to(get_viewport().get_mouse_position()) > 0.0):
					
					pass
		else:
			activeItemSlot = -1

func load_items():
	clear()
	for slot in range(0, 4):
		add_item("", null, false)
		update_slot(slot)
#func _on_ItemList_item_selected(index):
func update_slot(slot:int) -> void:
	if (slot < 0):
		return
	#print(Global_Player.inventory)
	var inventoryItem:Dictionary = inventory[str(slot)]
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
#	pass # Replace with function body.