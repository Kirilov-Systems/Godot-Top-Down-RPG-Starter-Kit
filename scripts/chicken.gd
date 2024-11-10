extends CharacterBody2D
var isWandering = true
var function_called = false
var end
var t = 0.0
var start


func wander():
	if function_called:
		while isWandering:
			goTo(select_random_position())
			await get_tree().create_timer(8).timeout
		#function_called = false
		



func _process(delta):
	if velocity != Vector2(0,0):
		$AnimatedSprite2D.play("walk")
		
	var speed = 1.0
	if isWandering:
		if !function_called:
			function_called = true
			wander()
	else:
		pass
		#runFromPlayer()


func select_random_position():
	var done = false

	while !done:
	
		var random_x = randi_range($".".global_position.x - 10, $".".global_position.x + 10)
		var random_y = randi_range($".".global_position.y - 10, $".".global_position.y + 10)
		var vector_pos = $"../TileMap".local_to_map(Vector2i(random_x, random_y))
		
		if $"../TileMap".get_cell_atlas_coords(1, vector_pos) != Vector2i(7, 0) and $"../TileMap".get_cell_atlas_coords(1, vector_pos) != Vector2i(-1, -1):
			done = true
			print("current ", str(position))
			print("goto ", str(vector_pos))
			print("\n")
			return vector_pos
			

func goTo(pos):
	end = pos
	start = global_position
	$AnimatedSprite2D.play("walk")
	
	while end[0] > position.x:
		position.x += 0.5
		$AnimatedSprite2D.flip_h = true
		await get_tree().create_timer(0.01).timeout
	
	while end[0] < position.x:
		position.x -= 0.5
		$AnimatedSprite2D.flip_h = false
		await get_tree().create_timer(0.01).timeout
		
	while end[1] > position.y:
		position.y += 0.5
		await get_tree().create_timer(0.01).timeout
		
		
	while end[1] < position.y:
		position.y -= 0.5
		await get_tree().create_timer(0.01).timeout
		
	var random = randi_range(1, 10)
	if random % 2 == 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	$AnimatedSprite2D.play("idle")
	
