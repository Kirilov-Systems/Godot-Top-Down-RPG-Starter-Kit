extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer
var itemStackGui: ItemStackGui
var index: int
@onready var inventory = preload("res://playerInventory.tres")

func insert(isg: ItemStackGui):
	itemStackGui = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackGui)
	itemStackGui.sprite.scale.x = 1
	itemStackGui.sprite.scale.y = 1
	
	if !itemStackGui.inventorySlot || inventory.slots[index] == itemStackGui.inventorySlot:
		return
	
	inventory.insertSlot(index, itemStackGui.inventorySlot)

func takeItem():
	var item = itemStackGui
	if item:
		item.visible = false
		item.sprite.scale.x = 5
		item.sprite.scale.y = 5
		
		container.remove_child(itemStackGui)
		itemStackGui = null
		backgroundSprite.frame = 0
		item.visible = true
		return item
	
	
func isEmpty():
	return !itemStackGui
