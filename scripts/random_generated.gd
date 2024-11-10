extends Node2D

@export var noise_height_text: NoiseTexture2D
var noise: Noise

var width: int = 100
var height: int = 100

var noise_val_arr = []

@onready var tile_map = $TileMap

var source_id_land = 9
var source_id_water = 15
var water_atlas = Vector2i(0, 0)
var land_atlas = Vector2i(3, 0)

func _ready():
	noise = noise_height_text.noise # a text a texture rövidítése
	generate_world()
	
func generate_world():
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_val = noise.get_noise_2d(x, y)
			#print(noise_val)
			if noise_val >= 0.0:
				tile_map.set_cell(0, Vector2(x,y), source_id_land, land_atlas)
				var random = randi_range(1, 1000000)
				if random % 67 == 0:
					place_tree(x * randi_range(1, 10), y * randi_range(1, 10))
			elif noise_val < 0.0:
				tile_map.set_cell(0, Vector2(x,y), source_id_water, water_atlas)
				

func place_tree(x, y):
	var tree = preload("res://scenes/tree.tscn")
	var treeInstace = tree.instantiate()
	var tree_coords = tile_map.local_to_map(Vector2(x,y))
	treeInstace.position = Vector2(randi_range(-width * 8, width * 8), randi_range(-height * 8, height * 8))
	treeInstace.visible = true
	$".".add_child(treeInstace)
