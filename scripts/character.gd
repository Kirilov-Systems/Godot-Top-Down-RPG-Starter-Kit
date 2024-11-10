extends CharacterBody2D

var speed = 70  # speed in pixels/sec
var dir = "down"
var on_dirt = false
var playing_footstep = false
@onready var tilemap = $"../gui"
@onready var dust = $dust
var idle = true
var using_item = false
var mouse_coords
@onready var hit_particles = $"../hit_particles"
var vect = get_global_mouse_position() - position
var mouse_position
var mouse_x
var mouse_y
@onready var hotbar = $Camera2D/CanvasLayer/Hotbar
@export var inventory_: Inventory
@onready var inventory = $Camera2D/CanvasLayer/InventoryGui
@onready var craft_menu = $Camera2D/CanvasLayer/craft_menu
var in_hand = ""
@export var log: InventoryItem


func _ready():
	$Camera2D/CanvasLayer/new_item.visible = false
	#hit_particles.emitting = false

func new_item(item_name,item_icon):
	$Camera2D/CanvasLayer/new_item.modulate.a = 100
	$Camera2D/CanvasLayer/new_item.text = "+1 " + item_name
	$Camera2D/CanvasLayer/new_item.visible = true
	await get_tree().create_timer(1).timeout
	while $Camera2D/CanvasLayer/new_item.modulate.a > 0:
		$Camera2D/CanvasLayer/new_item.modulate.a -= 0.01
		await get_tree().create_timer(0.01).timeout
	

func play_footstep():
	playing_footstep = true
	if velocity.x != 0 or velocity.y != 0:
		if on_dirt:
			$walk_dirt.pitch_scale = randi_range(0.7, 2)
			$walk_dirt.play()
			await get_tree().create_timer(0.3).timeout
		else:
			$walk_grass.pitch_scale = randi_range(1, 1.9)
			$walk_grass.play()
			await get_tree().create_timer(0.3).timeout
	playing_footstep = false

func wait(time):
	await get_tree().create_timer(time).timeout

func _input(event):
	if Input.is_action_pressed("scroll_up"):
		pass
	if Input.is_action_pressed("scroll_down"):
		pass
	if Input.is_action_pressed("left_click"):
		# Move as long as the key/button is pressed.
		if true:
			if true:
				if true:
					print("called")
					print(hotbar.in_hand)
					var path = str(hotbar.in_hand)
					var script = load(path)
					var script_ = script.new()
					script_.use($".", $AnimatedSprite2D, $axe_swing, hit_particles)
					await get_tree().create_timer(0.3).timeout
					idle = true
					using_item = false
					#hotbar.in_hand.use()
			elif in_hand == "Pickaxe":
				if !using_item:
					if position.x - mouse_x >= -60 and position.x - mouse_x <= 60:
						if position.y - mouse_y >= -60 and position.y - mouse_y <= 60:

							idle = false
							using_item = true
							$axe_swing.pitch_scale = 0.6
							$"../hit_particles".emitting = true
							if dir == "down":
								$AnimatedSprite2D.play("pickaxe")
							elif dir == "up":
								$AnimatedSprite2D.play("pickaxe_back")
							elif dir == "left":
								$AnimatedSprite2D.play("pickaxe_side")
								$AnimatedSprite2D.flip_h = true
							else:
								$AnimatedSprite2D.play("pickaxe_side")
								$AnimatedSprite2D.flip_h = false
							await get_tree().create_timer(0.3).timeout
							$axe_swing.play()
							await get_tree().create_timer(0.3).timeout
							idle = true
							using_item = false
	if Input.is_action_just_pressed("tab"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
	if Input.is_action_just_pressed("right_click"):
		print("set cell")
		$"../TileMap".set_cell(2, mouse_coords, 24, Vector2(1, 3))
		

func _process(delta):
	#position = $"../chicken".position
	mouse_position = get_global_mouse_position()
	mouse_x = mouse_position.x
	mouse_y = mouse_position.y
	mouse_coords = $"../TileMap".local_to_map(mouse_position)
	if !playing_footstep:
		play_footstep()
	
	hit_particles.position = get_global_mouse_position()
	var source_id = 0
	var atlas_coord = Vector2i(3, 1)
	


func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run_side")
		dir = "right"
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run_side")
		dir = "left"
	elif velocity.y > 0:
		$AnimatedSprite2D.play("run")
		dir = "down"
	elif velocity.y < 0:
		$AnimatedSprite2D.play("run_back")
		dir = "up"
	else:
		if idle:
			if dir == "down":
				$AnimatedSprite2D.play("idle")
			elif dir == "up":
				$AnimatedSprite2D.play("idle_back")
			elif dir == "left":
				$AnimatedSprite2D.play("idle_side")
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.play("idle_side")
				$AnimatedSprite2D.flip_h = false
	
						
			
	move_and_slide()
	


func _on_dirt_body_entered(body):
	if body.name == "character":
		on_dirt = true


func _on_dirt_body_exited(body):
	if body.name == "character":
		on_dirt = false


func _on_tree_body_entered(body):
	print(body.name)
