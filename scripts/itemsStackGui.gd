extends Panel

class_name ItemStackGui

@onready var itemSprite: Sprite2D = $item
@onready var amountLabel: Label = $Label
@onready var sprite = $item

var inventorySlot

func _ready():
	#print("ready")
	#sprite.scale.y = 100
	#sprite.scale.x = 100
	pass

func update():
	if !inventorySlot || !inventorySlot.item: return
	
	itemSprite.visible = true
	itemSprite.texture = inventorySlot.item.texture
	
	if inventorySlot.amount > 1:
		amountLabel.visible = true
		amountLabel.text = str(inventorySlot.amount)
	else:
		amountLabel.visible = false

		

