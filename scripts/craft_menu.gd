extends Control

@export var inventory_: Inventory
@onready var inventory = $Camera2D/CanvasLayer/InventoryGui
@onready var craft_menu = $Camera2D/CanvasLayer/craft_menu
var in_hand = 0
@onready var button1 = $log

@export var log: InventoryItem
signal updated

func craft(button):
	var index = -1
	for slot in inventory_.slots:
		index+=1
		if slot.item:
			#print(slot.item.name)
			if slot.item.name == button.component_1.name and slot.amount >= 2:
				print("craft log")
				#inventory_.removeItemAtIndex(2)
				slot.amount -= 2
				if slot.amount <= 0:
					inventory_.slots.erase(slot)
					inventory_.slots[index] = InventorySlot.new()
					slot.amount = 0
					#
					
					updated.emit()
					
				inventory_.insert(log)
			else:
				print("Can't craft!")
		else:
			pass


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if Input.is_action_just_pressed("tab"):
		if visible:
			visible = false
		else:
			visible = true


func _on_log_pressed():
	if visible:
		craft($log)
