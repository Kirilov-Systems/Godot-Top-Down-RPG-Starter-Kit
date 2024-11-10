extends Button

@export var item: InventoryItem
@export var amount: int

var component_1
var component_2


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Craft " + str(amount) +  " " + item.name
	component_1 = item.component1
	component_2 = item.component2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
