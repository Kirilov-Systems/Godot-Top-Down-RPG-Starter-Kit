extends Button

@onready var background_sprite: Sprite2D = $background
@onready var item_stack_gui: ItemStackGui = $CenterContainer/Panel


func update_to_slot(slot: InventorySlot) -> void:
	if !slot.item:
		item_stack_gui.visible = false
		background_sprite.frame = 0
		return
		
	$CenterContainer/Panel.sprite.scale.x = 4
	$CenterContainer/Panel.sprite.scale.y = 4
	$CenterContainer/Panel.sprite.position.y = -20
	$CenterContainer/Panel.sprite.position.x = -20
	item_stack_gui.inventorySlot = slot
	item_stack_gui.update()
	item_stack_gui.visible = true
	
	
