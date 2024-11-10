extends Area2D

var mouse = false
@onready var player = get_parent().get_node("character")
var life = 3
@onready var leaves = $"../rocks"
@export var itemRes: InventoryItem
#@onready var playerInventory = $"../character".inventory
var trunk
@onready var sprite = $AnimatedSprite2D
@onready var tilemap = $"../TileMap"
var playerInventory

func itemToInventory(inventory: Inventory):
	inventory.insert(itemRes)
	


func _input(event):
	var in_hand = $"../character".in_hand
	if Input.is_action_pressed("left_click"):
		# Move as long as the key/button is pressed.
		if in_hand == "Pickaxe":
			if player.velocity.y == 0 and player.velocity.x == 0:
				if !player.using_item:
					if player.position.x - player.mouse_x >= -60 and player.position.x - player.mouse_x <= 60:
						if player.position.y - player.mouse_y >= -60 and player.position.y - player.mouse_y <= 60:
							if mouse:
								await get_tree().create_timer(0.3).timeout
								$tree_hit.pitch_scale = randi_range(1, 2)
								$tree_hit.play()
								life-=1
								if life == 0:
									$tree_falling.play()
									#await get_tree().create_timer(6).timeout
									var rotate = 0.001
									
									leaves.position = position
									leaves.emitting = true
									player.new_item("Stone", "")
									playerInventory = player.inventory_
									itemToInventory(playerInventory)
									
									
									while $AnimatedSprite2D.modulate.a > 0:
										$AnimatedSprite2D.modulate.a -= 0.01
										await get_tree().create_timer(0.01).timeout
									queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
	#print(tilemap.local_to_map(position))
	get_parent().get_node("character")
	$".".visible = true
	#$".".top_level = true
	$AnimatedSprite2D.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	mouse = true


func _on_mouse_exited():
	mouse = false
