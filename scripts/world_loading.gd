extends TileMap

var window_size = get_viewport_rect().size
# Initialize noise generators for different map features
# Values between -1 and 1
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var refesh_thread: Thread

@export var noise_tree_text: NoiseTexture2D
var tree_noise: Noise

var player_tile_pos
# Dimensions of each generated chunk
var width = 64
var height = 64
var land_cells = []
var current_chunk

# Reference to the player character
@onready var player = $"../character"

# List to keep track of loaded chunks
var loaded_chunks = []

func _ready():
	tree_noise = noise_tree_text.noise
	# Set random seeds for noise variation
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()

	# Adjust this value to change the 'smoothness' of the map; lower values mean more smooth noise
	altitude.frequency = 0.01
	player_tile_pos = local_to_map(player.position)
	generate_chunk(player_tile_pos)
	
	

func _process(delta):
	#remove_layer(-1)
	#print(get_cell_atlas_coords(0, local_to_map(get_global_mouse_position())))
	# Convert the player's position to tile coordinates
	player_tile_pos = local_to_map(player.position)
	
	var chunk_distance_to_player = get_dist(current_chunk, player_tile_pos)
	if chunk_distance_to_player > 16 :
		print("gen_new_chunk")
		generate_chunk(player_tile_pos)

	# Generate the chunk at the player's position
	#generate_chunk(player_tile_pos)

	# Unload chunks that are too far away.
	# Note: Not needed for smaller projects but if you are loading a bigger tilemap it's good practice
	#load_new_chunks(player_tile_pos)
	unload_distant_chunks(player_tile_pos)


func generate_chunk(pos):
	land_cells = []
	var tree_num = 0
	var rock_num = 0
	for x in range(width):
		for y in range(height):
			# Generate noise values for moisture, temperature, and altitude
			var moist = moisture.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10 # Values between -10 and 10
			var temp = temperature.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			var alt = altitude.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			
			var posit
			if alt <= 0: # Arbitrary sea level value (choosing 0 will mean roughly 1/2 the world is ocean)
				posit = Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y)
				set_cell(1, posit, 18, Vector2(3, 0))
				#land_cells.append(posit)
				#set_cell(0, posit, 9, Vector2(16, 3))
				#if !(posit in land_cells): # Change x value where I've wrote three to whatever the x-coord of your oceans are
			elif alt > 1.9 / 4: # You can add other logic like making beaches by setting x-coord to whatever beach atlas x-coord is when the alt is between 0 and 0.5 or something
				posit = Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y)
				set_cell(1, posit, 14, Vector2(7, 0))
			else:
				posit = Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y)
				set_cell(1, posit, 13, Vector2(4, 2))
				# water below
				#posit = Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y)
				#set_cell(1, posit, 14, Vector2(7, 0))
			
			
				
				
			
			if tree_num < 30:
				var posi
				posi = Vector2(randi_range(player.position.x - 1000, player.position.x + 1000), randi_range(player.position.y - 1000, player.position.y + 1000))
				var cell_coords = local_to_map(posi)
				if get_cell_atlas_coords(1, cell_coords) == Vector2i(3, 0):
					tree_num+=1
					place_tree(posi)
					var random = randi_range(1, 10)
					
			if rock_num < 30:
				var posi
				posi = Vector2(randi_range(player.position.x - 1000, player.position.x + 1000), randi_range(player.position.y - 1000, player.position.y + 1000))
				var cell_coords = local_to_map(posi)
				if get_cell_atlas_coords(1, cell_coords) == Vector2i(3, 0):
					rock_num+=1
					place_rock(posi)
					var random = randi_range(1, 10)
					#if random == 3:
						#place_chicken(posi)
					
			
					
				

			
			
			if Vector2i(pos.x, pos.y) not in loaded_chunks:
				loaded_chunks.append(Vector2i(pos.x, pos.y))
				current_chunk = Vector2i(pos.x, pos.y)
			
	#print("settings cells")
	#set_cells_terrain_connect(1, land_cells, 0, 0, false)
	#print("done")
				

# Function to unload chunks that are too far away
func unload_distant_chunks(player_pos):
	# Set the distance threshold to at least 2 times the width to limit visual glitches
	# Higher values unload chunks further away
	var unload_distance_threshold = 64

	for chunk in loaded_chunks:
		var distance_to_player = get_dist(chunk, player_pos)

		if distance_to_player > unload_distance_threshold:
			print("unload")
			clear_chunk(chunk)
			loaded_chunks.erase(chunk)
			

func load_new_chunks(player_pos):
	for chunk in loaded_chunks:
		if chunk != player_pos:
			var distance_to_player = get_dist(chunk, player_pos)
			var load_distance_threshold = 0

			if distance_to_player >= load_distance_threshold:
				var thread = Thread.new()
				thread.start(generate_chunk.bind(player_tile_pos))
				#print("gen_chunk")
				#generate_chunk(player_tile_pos)
			

# Function to clear a chunk
func clear_chunk(pos):
	for x in range(width):
		for y in range(height):
			set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), -1, Vector2(-1, -1), -1)
			land_cells.erase(Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y))
			

# Function to calculate distance between two points
func get_dist(p1, p2):
	var resultant = p1 - p2
	return sqrt(resultant.x ** 2 + resultant.y ** 2)
	
	
func place_tree(position_to_place):
	var tree = preload("res://scenes/tree.tscn")
	var treeInstace = tree.instantiate()
	var tree_coords = local_to_map(position_to_place)
	treeInstace.position = position_to_place
	treeInstace.visible = true
	$"..".add_child(treeInstace)
	
	
func place_rock(position_to_place):
	var rock = preload("res://scenes/rock.tscn")
	var rockInstace = rock.instantiate()
	var rock_coords = local_to_map(position_to_place)
	rockInstace.position = position_to_place
	rockInstace.visible = true
	$"..".add_child(rockInstace)
	
	
func place_grass(position_to_place):
	var grass = preload("res://scenes/grass.tscn")
	var grassInstance = grass.instantiate()
	var grass_coords = local_to_map(position_to_place)
	grassInstance.position = position_to_place
	grassInstance.visible = true
	$"..".add_child(grassInstance)
	
func place_chicken(position_to_place):
	var chicken = preload("res://scenes/chicken.tscn")
	var chickenInstance = chicken.instantiate()
	var chicken_coords = local_to_map(position_to_place)
	chickenInstance.position = position_to_place
	chickenInstance.visible = true
	$"..".add_child(chickenInstance)
	
	
