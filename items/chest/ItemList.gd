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
	set_max_columns(10)
	set_fixed_icon_size(Vector2(32,32))
	set_icon_mode(ICON_MODE_TOP)
	set_select_mode(SELECT_SINGLE)
	set_same_column_width(true)
	set_allow_rmb_select(true)
	set_process(false)
	set_process_input(true)
	
	
	var dict:Dictionary = {"inventory":{}}
	for slot in range (0, Global_Player.inventory_maxSlots):
		var id_item = randi()%9+1
	
		dict["inventory"][str(slot)] = {"id": str(id_item), "amount": 1}
	#Global_DataParser.write_data(url_PlayerData, dict)
		inventory = dict["inventory"]
		
	load_items()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.


func load_items():
	clear()
	for slot in range(0, Global_Player.inventory_maxSlots):
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