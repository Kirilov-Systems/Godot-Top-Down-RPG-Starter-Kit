extends Node

@onready var player_ = $"../character"
@onready var player_sprite_ = $"../character/AnimatedSprite2D"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func use(player, player_sprite, sound, particle):
	print("use")
	if player.velocity.y == 0 and player.velocity.x == 0:
			if true:
				if !player.using_item:
					if player.position.x - player.mouse_x >= -60 and player.position.x - player.mouse_x <= 60:
						if player.position.y - player.mouse_y >= -60 and player.position.y - player.mouse_y <= 60:
							#$Camera2D.apply_shake()
							player.idle = false
							player.using_item = true
							sound.pitch_scale = 1
							sound.play()
							particle.emitting = true
							if player.dir == "down":
								player_sprite.play("axe")
							elif player.dir == "up":
								player_sprite.play("axe_back")
							elif player.dir == "left":
								player_sprite.play("axe_side")
								player_sprite.flip_h = true
							else:
								player_sprite.play("axe_side")
								player_sprite.flip_h = false

			
