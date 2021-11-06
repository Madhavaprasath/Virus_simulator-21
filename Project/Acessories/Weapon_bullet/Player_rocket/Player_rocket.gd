extends "res://Acessories/Weapon_bullet/Bullet.gd"

func _ready():
	$CollisionShape2D.disabled=false

func _process(delta):
	if shot:
		$Rocket_trail.add_point(global_position)
