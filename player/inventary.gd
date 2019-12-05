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
	if (int(itemData["id"])) < 1  or (int(itemData["id"])) == 1001: return
	var strItemInfo:String = ""

	#$WindowDialog_ItemMenu.set_position(get_viewport().get_mouse_position())
	$WindowDialog_ItemMenu.set_title(tr(str(itemData["name"])))
	$WindowDialog_ItemMenu/ItemMenu_TextureFrame_Icon.set_texture($inventory/bag1.get_item_icon(index))

	strItemInfo = tr("NAME_ITEM") +": [color=#00aedb] " + tr(str(itemData["name"])) + "[/color]\n"
	if itemData["type"] == "weapon":
		strItemInfo = strItemInfo + tr("DAMAGE_ITEM_TEXT") + ": [color=#b3cde0]" + tr(str(itemData["damage"])) + "[/color]\n"
	if itemData["str"] > 0:
		strItemInfo = strItemInfo + tr("STR_ITEM_TEXT") + ": [color=#b3cde0]" + tr(str(itemData["str"])) + "[/color]\n"
	if itemData["agi"] > 0:
		strItemInfo = strItemInfo + tr("AGI_ITEM_TEXT") + ": [color=#b3cde0]" + tr(str(itemData["agi"])) + "[/color]\n"
	if itemData["hp"] > 0:
		strItemInfo = strItemInfo + tr("HP_ITEM_TEXT") + ": [color=#b3cde0]" + tr(str(itemData["hp"])) + "[/color]\n"
	strItemInfo = strItemInfo + "\n [color=#b3cde0]" + tr(str(itemData["description"])) + "[/color]"

	$WindowDialog_ItemMenu/ItemMenu_RichTextLabel_ItemInfo.set_bbcode(strItemInfo)
	if itemData["quest"] == true:
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem.hide()
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem2.hide()
	elif itemData["quest"] == false:
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem.show()
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem.set_text("(" + String(itemData["amount"]) + ") " +tr("DROP_BUTTON"))
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem2.set_text("(" + String(itemData["amount"]) + ") " +tr("DROP_BUTTON"))
	$inventory/bag1.activeItemSlot = index
	$WindowDialog_ItemMenu.popup()
	if itemData["equip"] == true:
		$WindowDialog_ItemMenu/equip_button.show()
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem.show()
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem2.hide()
	elif itemData["equip"] == false and itemData["quest"] == false:
		$WindowDialog_ItemMenu/equip_button.hide()
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem.hide()
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem2.show()

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
		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem2.set_text("(" + String(newAmount) + ") " +tr("DROP_BUTTON"))
	$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)


	pass # Replace with function body.




func _on_Button_pressed():
	$inventory.hide()
	pass # Replace with function body.


func _on_inventory_mouse_entered():
	get_parent().button = true
	pass # Replace with function body.


func _on_inventory_mouse_exited():
	get_parent().button = false
	pass # Replace with function body.


func _on_equip_pressed():

#
#	if (newAmount < 1):
#		$WindowDialog_ItemMenu.hide()
#	else:
##		$WindowDialog_ItemMenu/ItemMenu_Button_DropItem.set_text("(" + String(newAmount) + ") " +tr("DROP_BUTTON"))
	if $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["type"] == "weapon":
		print(get_parent().get_node("Player_info/equip_panel/weapon/weapon").inventory)
		if get_parent().get_node("Player_info/equip_panel/weapon/weapon").inventory["id"] == "1001":

			get_parent().get_node("Player_info/equip_panel/weapon/weapon").update_slot(get_parent().get_node("Player_info/equip_panel/weapon/weapon").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().weapon_inventory = get_parent().get_node("Player_info/equip_panel/weapon/weapon").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			$WindowDialog_ItemMenu.hide()
		else:
			get_parent().get_node("Player_info/equip_panel/weapon")._on_ItemMenu_Button_DropItem_pressed()
	#		var newAmountt = get_parent().get_node("Player_info/equip_items").inventory_removeItem(0)
	#
	#		var player = get_tree().get_nodes_in_group("player")
	#		if player[0].get_node("inventary/inventory/bag1"):
	#			player[0].get_node("inventary/inventory/bag1").update_slot(Global_Player.inventory_addItem(int($weapon.get_item_metadata(0)["id"])))
	#		$weapon.update_slot(0)
			get_parent().get_node("Player_info/equip_panel/weapon/weapon").update_slot(get_parent().get_node("Player_info/equip_panel/weapon/weapon").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().weapon_inventory = get_parent().get_node("Player_info/equip_panel/weapon/weapon").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)

			$WindowDialog_ItemMenu.hide()
	if $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["type"] == "chest":
		print(get_parent().get_node("Player_info/equip_panel/chest/chest").inventory)
		if get_parent().get_node("Player_info/equip_panel/chest/chest").inventory["id"] == "0":
		
			get_parent().get_node("Player_info/equip_panel/chest/chest").update_slot(get_parent().get_node("Player_info/equip_panel/chest/chest").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().chest_inventory = get_parent().get_node("Player_info/equip_panel/chest/chest").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			$WindowDialog_ItemMenu.hide()
		else:
			get_parent().get_node("Player_info/equip_panel/chest")._on_ItemMenu_Button_DropItem_pressed()
	#		var newAmountt = get_parent().get_node("Player_info/equip_items").inventory_removeItem(0)
	#
	#		var player = get_tree().get_nodes_in_group("player")
	#		if player[0].get_node("inventary/inventory/bag1"):
	#			player[0].get_node("inventary/inventory/bag1").update_slot(Global_Player.inventory_addItem(int($weapon.get_item_metadata(0)["id"])))
	#		$weapon.update_slot(0)
			get_parent().get_node("Player_info/equip_panel/chest/chest").update_slot(get_parent().get_node("Player_info/equip_panel/chest/chest").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().chest_inventory = get_parent().get_node("Player_info/equip_panel/chest/chest").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			
			$WindowDialog_ItemMenu.hide()
	elif $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["type"] == "gloves":
		print(get_parent().get_node("Player_info/equip_panel/gloves/gloves").inventory)
		if get_parent().get_node("Player_info/equip_panel/gloves/gloves").inventory["id"] == "0":
		
			get_parent().get_node("Player_info/equip_panel/gloves/gloves").update_slot(get_parent().get_node("Player_info/equip_panel/gloves/gloves").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().gloves_inventory = get_parent().get_node("Player_info/equip_panel/gloves/gloves").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			$WindowDialog_ItemMenu.hide()
		else:
			get_parent().get_node("Player_info/equip_panel/gloves")._on_ItemMenu_Button_DropItem_pressed()
	#		var newAmountt = get_parent().get_node("Player_info/equip_items").inventory_removeItem(0)
	#
	#		var player = get_tree().get_nodes_in_group("player")
	#		if player[0].get_node("inventary/inventory/bag1"):
	#			player[0].get_node("inventary/inventory/bag1").update_slot(Global_Player.inventory_addItem(int($weapon.get_item_metadata(0)["id"])))
	#		$weapon.update_slot(0)
			get_parent().get_node("Player_info/equip_panel/gloves/gloves").update_slot(get_parent().get_node("Player_info/equip_panel/gloves/gloves").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().gloves_inventory = get_parent().get_node("Player_info/equip_panel/gloves/gloves").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			
			$WindowDialog_ItemMenu.hide()
	elif $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["type"] == "foot":
		print(get_parent().get_node("Player_info/equip_panel/foot/foot").inventory)
		if get_parent().get_node("Player_info/equip_panel/foot/foot").inventory["id"] == "0":
		
			get_parent().get_node("Player_info/equip_panel/foot/foot").update_slot(get_parent().get_node("Player_info/equip_panel/foot/foot").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().foot_inventory = get_parent().get_node("Player_info/equip_panel/foot/foot").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			$WindowDialog_ItemMenu.hide()
		else:
			get_parent().get_node("Player_info/equip_panel/foot")._on_ItemMenu_Button_DropItem_pressed()
	#		var newAmountt = get_parent().get_node("Player_info/equip_items").inventory_removeItem(0)
	#
	#		var player = get_tree().get_nodes_in_group("player")
	#		if player[0].get_node("inventary/inventory/bag1"):
	#			player[0].get_node("inventary/inventory/bag1").update_slot(Global_Player.inventory_addItem(int($weapon.get_item_metadata(0)["id"])))
	#		$weapon.update_slot(0)
			get_parent().get_node("Player_info/equip_panel/foot/foot").update_slot(get_parent().get_node("Player_info/equip_panel/foot/foot").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().foot_inventory = get_parent().get_node("Player_info/equip_panel/foot/foot").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			
			$WindowDialog_ItemMenu.hide()
	elif $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["type"] == "feet":
		print(get_parent().get_node("Player_info/equip_panel/feet/feet").inventory)
		if get_parent().get_node("Player_info/equip_panel/feet/feet").inventory["id"] == "0":
		
			get_parent().get_node("Player_info/equip_panel/feet/feet").update_slot(get_parent().get_node("Player_info/equip_panel/feet/feet").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().feet_inventory = get_parent().get_node("Player_info/equip_panel/feet/feet").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			$WindowDialog_ItemMenu.hide()
		else:
			get_parent().get_node("Player_info/equip_panel/feet")._on_ItemMenu_Button_DropItem_pressed()
	#		var newAmountt = get_parent().get_node("Player_info/equip_items").inventory_removeItem(0)
	#
	#		var player = get_tree().get_nodes_in_group("player")
	#		if player[0].get_node("inventary/inventory/bag1"):
	#			player[0].get_node("inventary/inventory/bag1").update_slot(Global_Player.inventory_addItem(int($weapon.get_item_metadata(0)["id"])))
	#		$weapon.update_slot(0)
			get_parent().get_node("Player_info/equip_panel/feet/feet").update_slot(get_parent().get_node("Player_info/equip_panel/feet/feet").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().feet_inventory = get_parent().get_node("Player_info/equip_panel/feet/feet").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			
			$WindowDialog_ItemMenu.hide()
	elif $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["type"] == "ring":
		print(get_parent().get_node("Player_info/equip_panel/ring/ring").inventory)
		if get_parent().get_node("Player_info/equip_panel/ring/ring").inventory["id"] == "0":
		
			get_parent().get_node("Player_info/equip_panel/ring/ring").update_slot(get_parent().get_node("Player_info/equip_panel/ring/ring").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().ring_inventory = get_parent().get_node("Player_info/equip_panel/ring/ring").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			$WindowDialog_ItemMenu.hide()
		else:
			get_parent().get_node("Player_info/equip_panel/ring")._on_ItemMenu_Button_DropItem_pressed()
	#		var newAmountt = get_parent().get_node("Player_info/equip_items").inventory_removeItem(0)
	#
	#		var player = get_tree().get_nodes_in_group("player")
	#		if player[0].get_node("inventary/inventory/bag1"):
	#			player[0].get_node("inventary/inventory/bag1").update_slot(Global_Player.inventory_addItem(int($weapon.get_item_metadata(0)["id"])))
	#		$weapon.update_slot(0)
			get_parent().get_node("Player_info/equip_panel/ring/ring").update_slot(get_parent().get_node("Player_info/equip_panel/ring/ring").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().ring_inventory = get_parent().get_node("Player_info/equip_panel/ring/ring").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			
			$WindowDialog_ItemMenu.hide()
	elif $inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["type"] == "neck":
		print(get_parent().get_node("Player_info/equip_panel/neck/neck").inventory)
		if get_parent().get_node("Player_info/equip_panel/neck/neck").inventory["id"] == "0":
		
			get_parent().get_node("Player_info/equip_panel/neck/neck").update_slot(get_parent().get_node("Player_info/equip_panel/neck/neck").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().neck_inventory = get_parent().get_node("Player_info/equip_panel/neck/neck").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			$WindowDialog_ItemMenu.hide()
		else:
			get_parent().get_node("Player_info/equip_panel/neck")._on_ItemMenu_Button_DropItem_pressed()
	#		var newAmountt = get_parent().get_node("Player_info/equip_items").inventory_removeItem(0)
	#
	#		var player = get_tree().get_nodes_in_group("player")
	#		if player[0].get_node("inventary/inventory/bag1"):
	#			player[0].get_node("inventary/inventory/bag1").update_slot(Global_Player.inventory_addItem(int($weapon.get_item_metadata(0)["id"])))
	#		$weapon.update_slot(0)
			get_parent().get_node("Player_info/equip_panel/neck/neck").update_slot(get_parent().get_node("Player_info/equip_panel/neck/neck").inventory_addItem(int($inventory/bag1.get_item_metadata($inventory/bag1.dropItemSlot)["id"])))
			get_parent().neck_inventory = get_parent().get_node("Player_info/equip_panel/neck/neck").inventory
			var newAmount = Global_Player.inventory_removeItem($inventory/bag1.dropItemSlot)
			$inventory/bag1.update_slot($inventory/bag1.dropItemSlot)
			
			$WindowDialog_ItemMenu.hide()
	
	
	pass # Replace with function body.


func _on_WindowDialog_ItemMenu2_popup_hide():
	pass # Replace with function body.
