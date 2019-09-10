extends ItemList

var empty_slot = ResourceLoader.load("res://player/inventory/empty_slot.png")
var max_slots = 4
var arrow_count_random
var inventory 
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
	
	
func load_items():
	clear()
	for slot in range(0, Global_Player.inventory_maxSlots):
		add_item("", null, false)
		update_slot(slot)


func update_slot(slot:int) -> void:
	if (slot < 0):
		return
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
	set_item_metadata(slot, itemMetaData["type"])
	set_item_tooltip(slot, itemMetaData["name"])
	set_item_tooltip_enabled(slot, int(inventoryItem["id"]) > 0)
#func _on_ItemList_item_selected(index):

#	pass # Replace with function body.
