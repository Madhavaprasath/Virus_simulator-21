extends "res://Platformer/Enemies/Enemies.gd"

onready var Rockets=get_node("Body/Rocket").Rockets

func _ready():
	pass

func Attack_player():
	if player:
		var direction=global_position.direction_to(player.global_position-Vector2(100,0))
		$Body.scale.x=sign(direction.x)
		velocity=Vector2()
		var pos=get_node("Body/Rocket/Position2D").global_position
		Global.emit_signal("spwan_bullet_direction",Rockets,pos,player,90*sign(direction.x),2)
		$reload_timer.start()

func _on_reload_timer_timeout():
	can_shoot=true
