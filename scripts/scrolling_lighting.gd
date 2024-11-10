extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(4).timeout
	#get_tree().change_scene_to_file("res://scenes/random_generated.tscn")
	SceneLoader.load_scene("res://scenes/main_menu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
