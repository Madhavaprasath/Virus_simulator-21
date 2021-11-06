extends "res://Platformer/Enemies/Enemies.gd"

onready var Bullet=get_node("Body/Gun").Bullet

func _ready():
	pass
func Attack_player():
	if player:
		var dir=global_position.direction_to(player.global_position)
		$Body.scale.x=sign(dir.x)
		velocity=Vector2()
		Global.emit_signal("spwan_bullet_direction",Bullet,get_node("Body/Gun/Position2D").global_position,Vector2(dir.x,0),0,1)
		$reload_timer.start()

func _on_reload_timer_timeout():
	can_shoot=true
