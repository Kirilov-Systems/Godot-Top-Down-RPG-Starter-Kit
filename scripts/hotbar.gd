extends Panel

@onready var inventory: Inventory = preload("res://playerInventory.tres")
@onready var slots: Array = $Container.get_children()
@onready var selector: Sprite2D = $Selector
var currently_selected: int = 0

var in_hand = null


# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	inventory.updated.connect(update)


func move_selector(up) -> void:
	$click.play()
	if up:
		currently_selected = (currently_selected + 1) % slots.size()
	else:
		currently_selected = (currently_selected - 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position + Vector2(5, 5)

func update() -> void:
	for i in range(slots.size()):
		var inventory_slot: InventorySlot = inventory.slots[i]
		slots[i].update_to_slot(inventory_slot)
	
func _unhandled_input(event) -> void:
	if event.is_action_pressed("left_click"):
		pass
	if event.is_action_pressed("scroll_up"):
		move_selector(false)
	if event.is_action_pressed("scroll_down"):
		move_selector(true)
		
func _process(delta):
	in_hand = inventory.slots[currently_selected].item.scriptToItem.resource_path
	#in_hand = inventory.slots[currently_selected].item.scriptToItem
	if in_hand:
		pass
