extends "res://Acessories/Weapon_bullet/Bullet.gd"


onready var explosion=get_node("explosion/AnimationPlayer")
func _ready():
	$CollisionShape2D.disabled=false

func _process(delta):
	if shot:
		$Rocket_trail.add_point(global_position)

func rocketmechs():
	explosion.play("Explode")
	yield(explosion,"animation_finished")
