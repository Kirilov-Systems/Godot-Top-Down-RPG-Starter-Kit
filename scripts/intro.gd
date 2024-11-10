extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D2.visible = true
	modulate.a8 = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if modulate.a8 != 255:
		modulate.a8 += 2
		print(modulate.a8)
	else:
		await get_tree().create_timer(2).timeout
		get_end()


func get_end():
	get_tree().change_scene_to_file("res://scenes/random_generated.tscn")
