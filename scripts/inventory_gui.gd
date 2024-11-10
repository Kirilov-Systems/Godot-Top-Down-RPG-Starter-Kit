extends Control

var isOpen = false

@onready var inventory: Inventory = preload("res://playerInventory.tres")
@onready var ItemStackGuiClass = preload("res://scenes/itemStackGui.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var itemInHand: ItemStackGui

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		if !inventorySlot.item: continue
		var itemStackGui: ItemStackGui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)
			
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()
			

# Called when the node enters the scene tree for the first time.
func _ready():
	connectSlots()
	inventory.updated.connect(update)
	close()
	update()
	

func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func open():
	visible = true
	isOpen = true
	
func close():
	visible = false
	isOpen = false
	
	
func swapItems(slot):
	var tempItem = slot.takeItem()
	insertIteminSlot(slot)
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()
	

func stackItems(slot):
	var slotItem: ItemStackGui = slot.ItemStackGui
	var maxAmount = slotItem.inventorySlot.item.maxAmountPrStack
	var totalAmount = slotItem.inventorySlot.item.amount + itemInHand.inventorySlot.amount
	
	if slotItem.inventorySlot.amount == maxAmount:
		swapItems(slot)
		return
		
	if totalAmount <= maxAmount:
		slotItem.inventorySlot.amount = totalAmount
		remove_child(itemInHand)
		itemInHand = null
	else:
		slotItem.inventorySlot.amount = maxAmount
		itemInHand.inventorySlot.amount = totalAmount - maxAmount
	
	slotItem.update()
	if itemInHand:
		itemInHand.update()

func onSlotClicked(slot):
	if slot.isEmpty() && itemInHand:
		insertIteminSlot(slot)
		return
	if !itemInHand:
		takeItemFromSlot(slot)
		return
	
	swapItems(slot)
	
func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand
	
func insertIteminSlot(slot):
	var item = itemInHand
	remove_child(itemInHand)
	itemInHand = null
	slot.insert(item)
	
func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2
	
func _input(event):
	updateItemInHand()
