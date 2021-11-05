extends "res://Platformer/Enemies/Enemies.gd"

onready var Rockets=get_node("Body/Rocket").Rockets

func _ready():
	pass

func Attack_player():
	if player:
		var direction=global_position.direction_to(player.global_position-Vector2(100,0))
		$Body.scale.x=sign(direction.x)
		velocity=Vector2()
		var c_g=Rockets.instance()
		c_g.global_position=get_node("Body/Rocket/Position2D").global_position
		c_g.fired=true
		c_g.rotation=90*sign(direction.x)
		c_g.tracking_target=player
		get_parent().add_child(c_g)
		$reload_timer.start()

func _on_reload_timer_timeout():
	can_shoot=true
