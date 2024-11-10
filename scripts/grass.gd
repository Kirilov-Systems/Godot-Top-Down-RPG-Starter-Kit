extends Area2D

var mouse = false
@onready var player = get_parent().get_node("character")
var life = 1
@onready var leaves = $"../leaves"
@export var itemRes: InventoryItem
#@onready var playerInventory = $"../character".inventory
@onready var sprite = $AnimatedSprite2D
@onready var tilemap = $"../TileMap"
var playerInventory

func itemToInventory(inventory: Inventory):
	inventory.insert(itemRes)
	


func _input(event):
	if Input.is_action_pressed("left_click"):
		# Move as long as the key/button is pressed.
		if true:
			if player.velocity.y == 0 and player.velocity.x == 0:
				if !player.using_item:
					if player.position.x - player.mouse_x >= -60 and player.position.x - player.mouse_x <= 60:
						if player.position.y - player.mouse_y >= -60 and player.position.y - player.mouse_y <= 60:
							if mouse:
								$tree_hit.pitch_scale = randi_range(1, 2)
								$tree_hit.play()
								life-=1
								if life == 0:
									$tree_falling.play()
									#await get_tree().create_timer(6).timeout
									var rotate = 0.001
									while $AnimatedSprite2D.rotation < 1.7:
										$AnimatedSprite2D.rotate(rotate + 0.01 * (rotate * 3000))
										
										await get_tree().create_timer(0.01).timeout
									
									leaves.position = position
									leaves.emitting = true
									player.new_item("Grass", "")
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	mouse = true


func _on_mouse_exited():
	mouse = false
