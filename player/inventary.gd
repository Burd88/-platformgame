extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_bag1_item_rmb_selected(index:int, atpos:Vector2) -> void:
	
	if ($inventory/bag1.isDraggingItem):
		return
	if ($inventory/bag1.isAwaitingSplit):
		return

	$inventory/bag1.dropItemSlot = index
	var itemData:Dictionary = $inventory/bag1.get_item_metadata(index)
	if (int(itemData["id"])) < 1: return
	var strItemInfo:String = ""

	#$WindowDialog_ItemMenu.set_position(get_viewport().get_mouse_position())
	$WindowDialog_ItemMenu.set_title(tr(str(itemData["name"])))
	$WindowDialog_ItemMenu/ItemMenu_TextureFrame_Icon.set_texture($inventory/bag1.get_item_icon(index))

	strItemInfo = tr("NAME_ITEM") +": [color=#00aedb] " + tr(str(itemData["name"])) + "[/color]\n"
	strItemInfo = strItemInfo + "\n [color=#b3cde0]" + tr(str(itemData["description"])) + "[/color]"

	$WindowDialog_ItemMenu/ItemMenu_RichTextLabel_ItemInfo.set_bbcode(strItemInfo)
	$WindowDialog_ItemMenu/ItemMenu_Button_DropItem.set_text("(" + String(itemData["amount"]) + ") " +tr("DROP_BUTTON"))
	$inventory/bag1.activeItemSlot = index
	$WindowDialog_ItemMenu.popup()

func _on_ItemMenu_Button_DropItem_pressed():
	if $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["name"] == "LESSER_HEAL_POTION":
		get_parent().lesser = false
	elif $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["name"] == "MINOR_HEAL_POTION":
		get_parent().minor = false
	elif $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["name"] == "HEAL_POTION":
		get_parent().norm = false
	elif $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["name"] == "BIG_HEAL_POTION":
		get_parent().big = false
	elif $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["name"] == "MAJOR_HEAL_POTION":
		get_parent().major = false
	var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)

	if (newAmount < 1):
		$WindowDialog_ItemMenu.hide()
	else:
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem.set_text("(" + String(newAmount) + ") " +tr("DROP_BUTTON"))
	$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)


	pass # Replace with function body.


