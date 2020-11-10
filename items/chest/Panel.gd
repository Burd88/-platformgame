extends Panel



var enter = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
var enterer = false
func _input(event):
	if GLOBAL.platform == "MOBILE":
		if event is InputEventScreenTouch and event.is_pressed() :
			enterer  = true
		#print("Touch")
func _on_ItemList_item_rmb_selected(index, at_position):
	if GLOBAL.platform == "PC":
		open_dialog(index)
	pass
func _on_ItemList_item_selected(index):
	if GLOBAL.platform == "MOBILE":
		if enterer:
			open_dialog(index)
	pass
func open_dialog(index):
		if ($ItemList.isDraggingItem):
			return
		if ($ItemList.isAwaitingSplit):
			return
	
		$ItemList.dropItemSlot = index
		var itemData:Dictionary = $ItemList.get_item_metadata(index)
		if (int(itemData["id"])) < 1  or (int(itemData["id"])) == 1001: return
		var strItemInfo:String = ""
	
		#$WindowDialog_ItemMenu.set_position(get_viewport().get_mouse_position())
		$WindowDialog_ItemMenu.set_title(tr(str(itemData["name"])))
		$WindowDialog_ItemMenu/ItemMenu_TextureFrame_Icon.set_texture($ItemList.get_item_icon(index))
	
		strItemInfo = tr("NAME_ITEM") +": [color=#00aedb] " + tr(str(itemData["name"])) + "[/color]\n"
		if itemData["type"] == "weapon":
			strItemInfo = strItemInfo + tr("DAMAGE_ITEM_TEXT") + ": [color=#b3cde0]" + tr(str(itemData["damage"])) + "[/color]\n"
		if int(itemData["str"]) > 0:
			strItemInfo = strItemInfo + tr("STR_ITEM_TEXT") + ": [color=#b3cde0]" + tr(str(itemData["str"])) + "[/color]\n"
		if itemData["agi"] > 0:
			strItemInfo = strItemInfo + tr("AGI_ITEM_TEXT") + ": [color=#b3cde0]" + tr(str(itemData["agi"])) + "[/color]\n"
		if itemData["hp"] > 0:
			strItemInfo = strItemInfo + tr("HP_ITEM_TEXT") + ": [color=#b3cde0]" + tr(str(itemData["hp"])) + "[/color]\n"
		strItemInfo = strItemInfo + "\n [color=#b3cde0]" + tr(str(itemData["description"])) + "[/color]"
	
		$WindowDialog_ItemMenu/ItemMenu_RichTextLabel_ItemInfo.set_bbcode(strItemInfo)
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem.show()
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem.set_text("(" + String(itemData["amount"]) + ") " +tr("COLLECT_BUTTON"))
		$ItemList.activeItemSlot = index
		$WindowDialog_ItemMenu.popup()
	
		pass # Replace with function body.
	
	
		pass # Replace with function body.



func _on_ItemList_mouse_entered():
	enter = true
	pass # Replace with function body.


func _on_ItemList_mouse_exited():
	enter = false
	pass # Replace with function body.



