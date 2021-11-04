extends "res://Platformer/Enemies/Enemies.gd"

onready var Bullet=get_node("Body/Gun").Bullet

func _ready():
	pass
func Attack_player():
	if player:
		var dir=global_position.direction_to(player.global_position)
		$Body.scale.x=sign(dir.x)
		velocity=Vector2()
		var c_g=Bullet.instance()
		c_g.global_position=get_node("Body/Gun/Position2D").global_position
		c_g.start(Vector2(dir.x,0),player.global_position)
		get_parent().add_child(c_g)
		$reload_timer.start()

func _on_reload_timer_timeout():
	can_shoot=true
